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
use Regex.Pattern.{Pattern};

namespace Regex {

    ///
    /// Represents a compiled Pattern.
    ///
    pub opaque type Pattern = ##java.util.regex.Pattern

}

namespace Regex/Pattern {

    ///
    /// Compile the regular expression `regex` into a Pattern.
    ///
    pub def compile(regex: String): Result[Pattern, String] & Impure =
        try {
            import java.util.regex.Pattern:compile(String);
            Ok(Pattern(compile(regex)))
        } catch {
            case _: ##java.util.regex.PatternSyntaxException => Err("compile - pattern syntax error")
        }

    ///
    /// Return the string representation of the Pattern `patt`.
    ///
    pub def toString(patt: Pattern): String & Impure =
        import java.util.regex.Pattern.toString();
        let Pattern(p1) = patt;
        p1.toString()

}