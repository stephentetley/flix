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

use Regex.Pattern;
use Regex.Pattern.Pattern;
use Regex/Internal.Matcher;

namespace Regex {

    ///
    /// Returns `true` if the entire string `input` is matched by the pattern `patt`.
    ///
    /// Note - use `isSubmatch` to search for a substring.
    ///
    pub def isMatch(patt: Pattern, input: String): Bool & Impure =
        use Regex/Internal/Matcher.{new, isMatch};
        let m1 = new(patt, input);
        m1.isMatch()

    ///
    /// Returns `true` if the string `s` is matched by the regular expression `pattern` at any point.
    ///
    pub def isSubmatch(patt: Pattern, input: String): Bool & Impure =
        use Regex/Internal/Matcher.{new, isSubmatch};
        let m1 = new(patt, input);
        m1.isSubmatch()

}