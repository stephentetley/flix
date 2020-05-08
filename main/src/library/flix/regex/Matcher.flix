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

    def apply1(x:Matcher[a], m: PrimMatcher): Result[a, Regex.Error] & Impure = 
        let Matcher(f) = x;
        f(m)


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


    pub def value(): Matcher[String] = 
        use Regex/Internal/PrimMatcher.{group};
        Matcher(r -> Ok(r.group()))

    // ///
    // /// Get the end index in the input of this MatchResult.
    // ///
    // pub def value(x: MatchResult): Result[String, String] & Impure =
    //     try {
    //         import java.util.regex.Matcher.group();
    //         let MatchResult(x1) = x;
    //         Ok(x1.group())
    //     } catch {
    //         case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
    //     }


    // ///
    // /// Get the start index in the input of this MatchResult.
    // ///
    // pub def getStart(x: MatchResult): Int32 & Impure =
    //     import java.util.regex.Matcher.start();
    //     let MatchResult(x1) = x;
    //     x1.start()

    // ///
    // /// Get the end index in the input of this MatchResult.
    // ///
    // pub def getEnd(x: MatchResult): Int32 & Impure =
    //     import java.util.regex.Matcher.end();
    //     let MatchResult(x1) = x;
    //     x1.end()

    // ///
    // /// Get the end index in the input of this MatchResult.
    // ///
    // pub def groupCount(a: MatchResult): Int32 & Impure =
    //     import java.util.regex.Matcher.groupCount();
    //     let MatchResult(m1) = a;
    //     m1.groupCount()

    // ///
    // /// Get the end index in the input of this MatchResult.
    // ///
    // pub def getGroupByName(a: MatchResult, name: String): Result[String, String] & Impure =
    //     try {
    //         import java.util.regex.Matcher.group(String);
    //         let MatchResult(m1) = a;
    //         Ok(m1.group(name))
    //     } catch {
    //         case _: ##java.lang.IllegalArgumentException => Err("getGroupByName - unknown group name")
    //         case _: ##java.lang.IllegalStateException => Err("getGroupByName - match error")
    //     }




}