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

use Regex/Internal.PrimMatcher;
use Regex/Internal.PrimMatcher.{PrimMatcher};


namespace Regex/Internal {

    ///
    /// Represents a mutable, matching engine for a Pattern.
    ///
    pub opaque type PrimMatcher = ##java.util.regex.Matcher

}

namespace Regex/Internal/PrimMatcher {

    ///
    /// Create a matcher for Pattern `patt` on the source String `input`.
    ///
    pub def newPrimMatcher(patt: ##java.util.regex.Pattern, input: String): PrimMatcher & Impure =
        import java.util.regex.Pattern.matcher(##java.lang.CharSequence);
        let cs1 = input as ##java.lang.CharSequence;
        PrimMatcher(patt.matcher(cs1))

    pub def isMatch(x: PrimMatcher): Bool & Impure =
        import java.util.regex.Matcher.matches();
        let PrimMatcher(x1) = x;
        x1.matches()

    pub def isSubmatch(x: PrimMatcher): Bool & Impure =
        import java.util.regex.Matcher.find();
        let PrimMatcher(x1) = x;
        x1.find()

    pub def replaceAll(x: PrimMatcher, rep: String): String & Impure =
        import java.util.regex.Matcher.replaceAll(String);
        let PrimMatcher(x1) = x;
        x1.replaceAll(rep)

    pub def replaceFirst(x: PrimMatcher, rep: String): String & Impure =
        import java.util.regex.Matcher.replaceFirst(String);
        let PrimMatcher(x1) = x;
        x1.replaceFirst(rep)

    pub def find(x: PrimMatcher): Bool & Impure =
        import java.util.regex.Matcher.find();
        let PrimMatcher(x1) = x;
        x1.find()

    /// TODO - handle exceptions
    pub def appendReplacement(x: PrimMatcher, sb: StringBuilder, rep: String): Unit & Impure =
        import java.util.regex.Matcher.appendReplacement(##java.lang.StringBuilder, String);
        let PrimMatcher(x1) = x;
        let StringBuilder(sb1) = sb;
        x1.appendReplacement(sb1, rep);
        ()

    /// TODO - handle exceptions
    pub def appendTail(x: PrimMatcher, sb: StringBuilder): Unit & Impure =
        import java.util.regex.Matcher.appendTail(##java.lang.StringBuilder);
        let PrimMatcher(x1) = x;
        let StringBuilder(sb1) = sb;
        x1.appendTail(sb1);
        ()

    /// TODO - handle exceptions
    pub def group(x: PrimMatcher): String & Impure =
        import java.util.regex.Matcher.group();
        let PrimMatcher(m1) = x;
        m1.group()

    pub def replaceAllWith(x: PrimMatcher, f: String -> String): String & Impure =
        let sb = StringBuilder.new();
        replaceAllWithHelper(x, f, sb);
        StringBuilder.toString(sb)

    pub def replaceAllWithHelper(x: PrimMatcher, f: String -> String, sb: StringBuilder): Unit & Impure =
        if (x.find() == false)
            x.appendTail(sb)
        else {
            let sub = x.group();
            let rep = f(sub);
            x.appendReplacement(sb, rep);
            replaceAllWithHelper(x, f, sb)
        }

    pub def replaceAllWithIndex(x: PrimMatcher, f: (String, Int32) -> String): String & Impure =
        let sb = StringBuilder.new();
        replaceAllWithIndexHelper(x, f, sb, 0);
        StringBuilder.toString(sb)

    pub def replaceAllWithIndexHelper(x: PrimMatcher, f: (String, Int32) -> String, sb: StringBuilder, ix: Int32): Unit & Impure =
        if (x.find() == false)
            x.appendTail(sb)
        else {
            let sub = x.group();
            let rep = f(sub, ix);
            x.appendReplacement(sb, rep);
            replaceAllWithIndexHelper(x, f, sb, ix+1)
        }

    // pub def getMatch(x: PrimMatcher): Option[PrimMatcher] & Impure =
    //     import java.util.regex.Matcher.find();
    //     let PrimMatcher(m1) = x;
    //     if (m1.find() == false)
    //         None
    //     else
    //         Some(PrimMatcher(m1))

}