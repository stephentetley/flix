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
/// Represents a mutable, matching engine for a Pattern.
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
        import java.util.regex.Pattern.matcher(##java.lang.CharSequence);
        let Pattern(p1) = patt;
        let input1 = input as ##java.lang.CharSequence;
        Matcher(p1.matcher(input1)) as & Pure

    ///
    /// Asserts whether them Matcher `m` matches its entire input.
    ///
    pub def matches(m: Matcher): Bool =
        import java.util.regex.Matcher.matches();
        let Matcher(m1) = m;
        m1.matches() as & Pure

    ///
    ///  __ find __
    ///
    pub def find(m: Matcher): Bool & Impure =
        import java.util.regex.Matcher.find();
        let Matcher(m1) = m;
        m1.find()

    ///
    ///  __ start __
    ///
    pub def start(m: Matcher): Int32 & Impure =
        import java.util.regex.Matcher.start();
        let Matcher(m1) = m;
        m1.start()

    ///
    ///  __ end __
    ///
    pub def end(m: Matcher): Int32 & Impure =
        import java.util.regex.Matcher.end();
        let Matcher(m1) = m;
        m1.end()

    ///
    ///  __ group __
    ///
    pub def group(m: Matcher): String & Impure =
        import java.util.regex.Matcher.group();
        let Matcher(m1) = m;
        m1.group()

    ///
    ///  __ namedGroup __
    ///
    pub def namedGroup(m: Matcher, name: String): String & Impure =
        import java.util.regex.Matcher.group(String);
        let Matcher(m1) = m;
        m1.group(name)

    ///
    ///  __ reset __
    ///
    pub def reset(m: Matcher): Unit & Impure =
        import java.util.regex.Matcher.reset();
        let Matcher(m1) = m;
        m1.reset();
        ()

}