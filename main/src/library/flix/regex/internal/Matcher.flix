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

use Regex/Internal.Matcher;
use Regex/Internal.Matcher.{Matcher};
use Regex/Internal.MatchResult;
use Regex/Internal.MatchResult.{MatchResult};
use Regex.Pattern;
use Regex.Pattern.{Pattern};


namespace Regex/Internal {

    ///
    /// Represents a mutable, matching engine for a Pattern.
    ///
    pub opaque type Matcher = ##java.util.regex.Matcher

}

namespace Regex/Internal/Matcher {

    ///
    /// Create a matcher for Pattern `patt` on the source String `input`.
    ///
    pub def new(patt: Pattern, input: String): Matcher & Impure =
        import java.util.regex.Pattern.matcher(##java.lang.CharSequence);
        let Pattern(p1) = patt;
        let cs1 = input as ##java.lang.CharSequence;
        Matcher(p1.matcher(cs1))

    pub def isMatch(x: Matcher): Bool & Impure =
        import java.util.regex.Matcher.matches();
        let Matcher(m1) = x;
        m1.matches()

    pub def isSubmatch(x: Matcher): Bool & Impure =
        import java.util.regex.Matcher.find();
        let Matcher(m1) = x;
        m1.find()

    pub def getMatch(x: Matcher): Option[MatchResult] & Impure =
        import java.util.regex.Matcher.find();
        let Matcher(m1) = x;
        if (m1.find() == false)
            None
        else
            Some(MatchResult(m1))

}