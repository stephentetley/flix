/*
 * Copyright 2020 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use Regex.Matcher;
use Regex.Matcher.{Matcher};
use Regex.Error.{PatternSyntaxException, IllegalStateException};
use Regex/Internal.PrimMatcher;
use Regex.Pattern;
use Regex.Pattern.{Pattern};

namespace Regex {

    ///
    /// Matcher is a monad (reader, error).
    ///
    pub opaque type Matcher[a] = PrimMatcher ~> Result[a, Regex.Error] 

}

namespace Regex/Matcher {

    /// TODO - Can we generate a Stream through a run function?

    pub def runMatcher(x: Matcher[a], patt: Pattern, input: String): Result[a, Regex.Error] & Impure = 
        use Regex/Internal/PrimMatcher.{newPrimMatcher, isMatch};
        let Pattern(p1) = patt;
        let Matcher(f) = x;
        let m1 = newPrimMatcher(p1, input);
        f(m1)

    pub def runMatcherCompilePattern(x: Matcher[a], patt: String, input: String): Result[a, Regex.Error] & Impure = 
        use Regex/Internal/PrimMatcher.{newPrimMatcher, isMatch};
        match Regex/Pattern.compile(patt) {
            case Ok(p) => {
                let Pattern(p1) = p;
                let Matcher(f) = x;
                let m1 = newPrimMatcher(p1, input);
                f(m1)
            }
            case Err(e) => Err(e)
        }

    pub def return(x: a): Matcher[a] = 
        Matcher(_ -> Ok(x) as & Impure)

    pub def map(f: a -> b, x: Matcher[a]): Matcher[b] = 
        Matcher(r -> 
            let Matcher(f1) = x;
            match f1(r) { 
                case Ok(a) => Ok(f(a))
                case Err(e) => Err(e)
            }
        )        

    def apply1(x:Matcher[a], m: PrimMatcher): Result[a, Regex.Error] & Impure = 
        let Matcher(f) = x;
        f(m)

    pub def ap(mf: Matcher[a -> b], x: Matcher[a]): Matcher[b] = 
        Matcher(r -> 
            let Matcher(f1) = mf;
            match f1(r) { 
                case Ok(f) => { 
                    let Matcher(f2) = x;
                    match f2(r) {
                        case Ok(a) => Ok(f(a))
                        case Err(e2) => Err(e2)
                    }
                    
                }
                case Err(e1) => Err(e1)
            }
        )

    pub def bind(x: Matcher[a], k: a -> Matcher[b]): Matcher[b] = 
        Matcher(r -> 
            let Matcher(f) = x;
            match f(r) { 
                case Ok(a) => apply1(k(a), r)
                case Err(e) => Err(e)
            }
        )

    pub def flatMap(k: a -> Matcher[b], x: Matcher[a]): Matcher[b] = bind(x, k)


    pub def liftAction(action: Unit -> a & e): Matcher[a] = 
        Matcher(_ -> 
            let a = action();
            Ok(a)
        )


    def liftPrimOk(fn : PrimMatcher ~> a): Matcher[a] = 
        Matcher(r -> 
            let a = fn(r) as & Impure;
            Ok(a)
        )

    def liftPrim(fn : PrimMatcher ~> Result[a, Regex.Error]): Matcher[a] = 
        Matcher(r -> fn(r))


    pub def find(): Matcher[Bool] = liftPrimOk(Regex/Internal/PrimMatcher.find)


    pub def getValue(): Matcher[String] = liftPrim(Regex/Internal/PrimMatcher.group)


    pub def getStart(): Matcher[Int32] = 
        liftPrim(Regex/Internal/PrimMatcher.start)

    pub def getEnd(): Matcher[Int32] = liftPrim(Regex/Internal/PrimMatcher.end)
        
    ///
    /// Returns the number of groups in the pattern used by the matcher.
    ///
    pub def groupCountInPattern(): Matcher[Int32] =
        liftPrimOk(Regex/Internal/PrimMatcher.groupCount)
        
    pub def groupElementByIndex(ix: Int32): Matcher[String] = 
        liftPrim(x -> Regex/Internal/PrimMatcher.groupElementByIndex(x, ix))

    pub def groupElementByName(label: String): Matcher[String] = 
        liftPrim(x -> Regex/Internal/PrimMatcher.groupElementByName(x, label))

    ///
    /// Return the list of results form applying `x` to every match in the input string.
    ///
    pub def everyMatch(x: Matcher[a]): Matcher[List[a]] = everyMatchHelper(x, xs -> xs)

    def everyMatchHelper(x: Matcher[a], k: List[a] -> List[a]): Matcher[List[a]] = 
        let* more = find();
        if (!more)
            return(k(Nil))
        else {
            let* a = x;
            everyMatchHelper(x, xs -> k(a :: xs))
        }

    pub def foreachMatch(x: Matcher[a]): Matcher[Unit] = foreachMatchHelper(x)

    def foreachMatchHelper(x: Matcher[a]): Matcher[Unit] = 
        let* more = find();
        if (!more)
            return()
        else {
            let* _ = x;
            foreachMatchHelper(x)
        }

    pub def foldMatches(f: (a,b) -> b, st: b, x: Matcher[a]): Matcher[b] =
        let* more = find();
        if (!more)
            return(st)
        else {
            let* a = x;
            let st2 = f(a, st);
            foldMatches(f, st2, x)
        }

    /// Strategy for rewriting strings?

    def appendReplacement!(sb: StringBuilder, rep: String): Matcher[Unit] =
        liftPrim(x -> Regex/Internal/PrimMatcher.appendReplacement!(x, sb, rep))

    def appendTail!(sb: StringBuilder): Matcher[Unit] =
        liftPrimOk(x -> Regex/Internal/PrimMatcher.appendTail!(x, sb))


    pub def rewriteSource(rep: String -> String & e): Matcher[String] = 
        let* sb = liftAction(_ -> StringBuilder.new());
        rewriteSourceHelper(sb, rep)


    def rewriteSourceHelper(sb: StringBuilder, rep: String -> String & e): Matcher[String] = 
        let* more = find();
        if (!more) {
            let* _ = appendTail!(sb);
            let* s = liftAction(_ -> StringBuilder.toString(sb));
            return(s)
        } else {
            let* s = getValue();
            let* s1 = liftAction(_ -> rep(s) as & Impure);
            let* _ = appendReplacement!(sb, s1);
            rewriteSourceHelper(sb, rep)
        }



}