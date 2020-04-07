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

use Regex.MatchResult;
use Regex.MatchResult.{MatchResult};

namespace Regex {

    ///
    /// The result of a match operation.
    ///
    opaque type MatchResult = ##java.util.regex.Matcher

}

namespace Regex/MatchResult {

    ///
    /// Get the start index in the input of this MatchResult.
    ///
    pub def getStart(a: MatchResult): Int32 & Impure =
        import java.util.regex.Matcher.start();
        let MatchResult(m1) = a;
        m1.start()

    ///
    /// Get the end index in the input of this MatchResult.
    ///
    pub def getEnd(a: MatchResult): Int32 & Impure =
        import java.util.regex.Matcher.end();
        let MatchResult(m1) = a;
        m1.end()

    ///
    /// Get the end index in the input of this MatchResult.
    ///
    pub def groupCount(a: MatchResult): Int32 & Impure =
        import java.util.regex.Matcher.groupCount();
        let MatchResult(m1) = a;
        m1.groupCount()

    ///
    /// Get the end index in the input of this MatchResult.
    ///
    pub def getGroupByName(a: MatchResult, name: String): Result[String, String] & Impure =
        try {
            import java.util.regex.Matcher.group(String);
            let MatchResult(m1) = a;
            Ok(m1.group(name))
        } catch {
            case _: ##java.lang.IllegalArgumentException => Err("getGroupByName - unknown group name")
            case _: ##java.lang.IllegalStateException => Err("getGroupByName - match error")
        }

    ///
    /// Get the end index in the input of this MatchResult.
    ///
    pub def getMatchedSubstring(a: MatchResult): Result[String, String] & Impure =
        try {
            import java.util.regex.Matcher.group();
            let MatchResult(m1) = a;
            Ok(m1.group())
        } catch {
            case _: ##java.lang.IllegalStateException => Err("getMatchedSubstring - match error")
        }
}