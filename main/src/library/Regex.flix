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

///
/// Represents a compiled Pattern.
///
opaque type Pattern = ##java.util.regex.Pattern

///
/// Represents a matching engine for a Pattern.
///
opaque type Matcher = ##java.util.regex.Matcher

namespace Regex {

    ///
    /// Compile the regular expression `regex` into a Pattern.
    ///
    pub def compile(regex: String): Pattern =
        import java.util.regex.Pattern:compile(String);
        Pattern(compile(regex) as & Pure)

    ///
    /// Return the string representation of the Pattern `patt`.
    ///
    pub def toString(patt: Pattern): String =
        import java.util.regex.Pattern.toString();
        let Pattern(p1) = patt;
        p1.toString() as & Pure

    ///
    /// Return a literal pattern string for the the String `s`.
    ///
    pub def quote(s: String): String =
        import java.util.regex.Pattern:quote(String);
        quote(s) as & Pure

    ///
    /// Create a matcher for Pattern `patt` on the source String `input`.
    ///
    pub def matcher(patt: Pattern, input: String): Matcher =
        import flix.runtime.library.RegexWrapper:matcher(##java.util.regex.Pattern, String);
        let Pattern(p1) = patt;
        Matcher(matcher(p1, input) as & Pure)

    ///
    /// Create a matcher for Pattern `patt` on the source String `input`.
    ///
    pub def matches(m: Matcher): Bool =
        import java.util.regex.Matcher.matches();
        let Matcher(m1) = m;
        m1.matches() as & Pure

}