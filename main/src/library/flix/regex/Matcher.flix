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


    pub def find(): Matcher[Bool] = 
        use Regex/Internal/PrimMatcher.{find};
        Matcher(r -> Ok(r.find()))


    pub def getValue(): Matcher[String] = 
        use Regex/Internal/PrimMatcher.{group};
        Matcher(r -> r.group())

    pub def getStart(): Matcher[Int32] = 
        use Regex/Internal/PrimMatcher.{start};
        Matcher(r -> r.start())

    pub def getEnd(): Matcher[Int32] = 
        use Regex/Internal/PrimMatcher.{end};
        Matcher(r -> r.end())

    ///
    /// Returns the number of groups in the pattern used by the matcher.
    ///
    pub def groupCountInPattern(): Matcher[Int32] =
        use Regex/Internal/PrimMatcher.{groupCount};
        Matcher(r -> Ok(r.groupCount()))

    pub def groupElementByIndex(ix: Int32): Matcher[String] = 
        use Regex/Internal/PrimMatcher.{groupElementByIndex};
        Matcher(r -> r.groupElementByIndex(ix))


    pub def groupElementByName(label: String): Matcher[String] = 
        use Regex/Internal/PrimMatcher.{groupElementByName};
        Matcher(r -> r.groupElementByName(label))

    ///
    /// Return the list of results form applying `x` to every match in the input string.
    ///
    pub def everyMatch(x: Matcher[a]): Matcher[List[a]] = everyMatchHelper(x, xs -> xs)

    def everyMatchHelper(x: Matcher[a], k: List[a] -> List[a]): Matcher[List[a]] = 
        let* done = map(a1 -> !a1, find());
        if (done)
            return(k(Nil))
        else {
            let* a = x;
            everyMatchHelper(x, xs -> k(a :: xs))
        }


    



}