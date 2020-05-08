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
use Regex.Error.{PatternSyntaxException, Generic};

namespace Regex {

    ///
    /// Represents a compiled Pattern.
    ///
    pub opaque type Pattern = ##java.util.regex.Pattern

}

namespace Regex/Pattern {

    pub enum Flag {
        case CanonEq,
        case CaseInsenstive,
        case Comments,
        case Dotall,
        case Literal,
        case Multiline,
        case UnicodeCase,
        case UnicodeCharacterClass,
        case UnixLines
    }

    def toInt(flag: Flag): Int32 =
        import get java.util.regex.Pattern:CANON_EQ as getCanonEq;
        import get java.util.regex.Pattern:CASE_INSENSITIVE as getCaseInsensitive;
        import get java.util.regex.Pattern:COMMENTS as getComments;
        import get java.util.regex.Pattern:DOTALL as getDotall;
        import get java.util.regex.Pattern:LITERAL as getLiteral;
        import get java.util.regex.Pattern:MULTILINE as getMultiline;
        import get java.util.regex.Pattern:UNICODE_CASE as getUnicodeCase;
        import get java.util.regex.Pattern:UNICODE_CHARACTER_CLASS as getUnicodeCharacterClass;
        import get java.util.regex.Pattern:UNIX_LINES as getUnixLines;
        match flag {
            case CanonEq                => getCanonEq()
            case CaseInsenstive         => getCaseInsensitive()
            case Comments               => getComments()
            case Dotall                 => getDotall()
            case Literal                => getLiteral()
            case Multiline              => getMultiline()
            case UnicodeCase            => getUnicodeCase()
            case UnicodeCharacterClass  => getUnicodeCharacterClass()
            case UnixLines              => getUnixLines()
        } as & Pure

    def sumFlags(flags: List[Flag]): Int32 =
        List.foldLeft((ac,e) -> ac + toInt(e), 0, flags)

    ///
    /// Compile the regular expression `regex` into a Pattern.
    ///
    pub def compile(regex: String): Result[Pattern, Regex.Error] =
        try {
            import java.util.regex.Pattern:compile(String);
            Ok(Pattern(compile(regex))) as & Pure
        } catch {
            case _: ##java.util.regex.PatternSyntaxException => Err(PatternSyntaxException)
        }

    ///
    /// Compile the regular expression `regex` into a Pattern.
    ///
    pub def compileWithFlags(regex: String, flags: List[Flag]): Result[Pattern, Regex.Error] =
        try {
            import java.util.regex.Pattern:compile(String, Int32);
            Ok(Pattern(compile(regex, sumFlags(flags)))) as & Pure
        } catch {
            case _: ##java.util.regex.PatternSyntaxException => Err(PatternSyntaxException)
            case _: ##java.lang.IllegalArgumentException =>  Err(Generic("Regex/Pattern.compileWithFlags - illegal argument error"))
        }


    pub def quote(s: String): String =
        import java.util.regex.Pattern:quote(String);
        s.quote() as & Pure


    ///
    /// Return the string representation of the Pattern `patt`.
    ///
    pub def toString(patt: Pattern): String =
        import java.util.regex.Pattern.toString();
        let Pattern(p1) = patt;
        p1.toString() as & Pure



}