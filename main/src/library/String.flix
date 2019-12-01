/*
 * Copyright 2017 Magnus Madsen
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
namespace String {

    ///
    /// Returns the character at position `i` in the string `s`.
    ///
    pub def charAt(i: Int, s: Str): Char = native method java.lang.String.charAt(s, i) as Char

    ///
    /// Returns the string `s1` followed by the string `s2`.
    ///
    pub def concat(s1: Str, s2: Str): Str = s1 + s2

    ///
    /// Returns `true` if the string `s1` ends with the string `s2`.
    ///
    pub def endsWith(s1: Str, s2: Str): Bool = native method java.lang.String.endsWith(s1, s2) as Bool

    ///
    /// Returns `true` if the string `s` is the empty string.
    ///
    pub def isEmpty(s: Str): Bool = native method java.lang.String.isEmpty(s) as Bool

    ///
    /// Returns the length of the string `s`.
    ///
    pub def length(s: Str): Int = native method java.lang.String.length(s) as Int

    ///
    /// Returns `true` if the string `s1` starts with the string `s2`.
    ///
    pub def startsWith(s1: Str, s2: Str): Bool = native method java.lang.String.startsWith(s1, s2) as Bool

    ///
    /// Splits the string `s` around matches of the regular expression `r`.
    ///
    pub def split(s: Str, r: Str): Array[Str] = native method java.lang.String.split(s, r) as Array[Str]

    //
    // Returns the lower case version of the string `s`.
    //
    pub def toLowerCase(s: Str): Str = native method java.lang.String.toLowerCase(s) as Str

    //
    // Returns the upper case version of the string `s`.
    //
    pub def toUpperCase(s: Str): Str = native method java.lang.String.toUpperCase(s) as Str

    ///
    /// Returns the given string `s` as a list of characters.
    ///
    pub def toList(s: Str): List[Char] = List.map(i -> charAt(i, s), List.range(0, length(s)))

    ///
    /// Returns a copy of the string `s` without trailing and leading whitespaces.
    /// Returns a new empty string if there is no characters in `s`.
    ///
    pub def trim(s: Str): Str = native method java.lang.String.trim(s) as Str

    ///
    /// Returns the given string `s` as an array of characters.
    ///
    pub def toArray(s: Str): Array[Char] =
        Array.init(i -> charAt(i, s), length(s))

    ///
    /// Build a string of length `len` by applying `f` to the successive indices.
    ///
    pub def init(f: Int32 -> Char, len: Int32): Str =
        if (len <= 0)
            ""
        else {
            let c = f(0);
            let a = Array.new(c, len);
            initHelper(a, f, 1);
            Array.toString(a)
        }

    ///
    /// Helper function for `init`.
    ///
    def initHelper(a: Array[Char], f: Int32 -> Char, i: Int32): Unit =
        if (i >= Array.length(a) || i > 10)
            ()
        else {
            a[i] = f(i);
            initHelper(a, f, i+1)
        }


    ///
    /// Returns the result of applying `f` to every character in `s`.
    ///
    pub def map(f: Char -> Char, s: Str): Str =
        let len = length(s);
        init(i -> f(charAt(i, s)), len)

    ///
    /// Returns the result of applying `f` to every character in `s` along with that character's index.
    ///
    pub def mapWithIndex(f: (Char, Int32) -> Char, s: Str): Str =
        let len = length(s);
        init(i -> f(charAt(i, s), i), len)

    ///
    /// Returns a string where the element at index `i` is `f(a, b)` where
    /// `a` is the element at index `i` in `s` and `b` is the element at index `i` in `t`.
    ///
    /// If either `s` or `t` becomes depleted, then no further elements are added to the resulting string.
    /// Functionally equivalent to zipWith.
    ///
    pub def map2(f: (Char, Char) -> Char, s: Str, t: Str): Str =
        let len = length(s);
        init(i -> f(charAt(i, s), charAt(i, t)), len)


    ///
    /// Returns `true` if the string `s` matches the `regex`.
    ///
    pub def matches(s: Str, regex: Str): Bool = native method java.lang.String.matches(s, regex) as Bool

    ///
    /// Returns the hash code of the string `s`.
    ///
    pub def hashCode(s: Str): Int = native method java.lang.String.hashCode(s) as Int



    ///
    /// Returns the substring of `s` from index `b` (inclusive) to index `e` (exclusive).
    ///
    /// If `b` or `e` are out-of-bounds, return the empty string.
    ///
    pub def slice(b: Int, e: Int, s: Str) : Str = try {
        native method java.lang.String.substring(s, b, e) as Str
    } catch {
        case _: ##java.lang.IndexOutOfBoundsException => ""
    }

    ///
    /// Alias for `takeLeft`.
    ///
    pub def take(n: Int, s: Str) : Str = takeLeft(n, s)

    ///
    /// Take the first `n` characters of string `s` from the left.
    ///
    /// If `n` extends past the end of string `s`, return all the characters
    /// of `s`.
    ///
    pub def takeLeft(n: Int, s: Str) : Str = slice(0, n, s)

    ///
    /// Take the last `n` characters of string `s` from the right.
    ///
    /// If `n` is greater than the length of string `s`, return all the characters
    /// of `s`.
    ///
    pub def takeRight(n: Int, s: Str) : Str =
        let len = length(s);
        slice(len - n, len, s)

    ///
    /// Alias for `dropLeft`.
    ///
    pub def drop(n: Int, s: Str) : Str = dropLeft(n, s)

    ///
    /// Drop the first `n` characters of string `s` from the left.
    ///
    /// If `n` extends past the end of string s, return the empty string.
    ///
    pub def dropLeft(n: Int, s: Str) : Str =
        let len = length(s);
        slice(n, len, s)

    ///
    /// Drop the last `n` characters of string `s` from the right.
    ///
    /// If `n` is greater than the length of string `s`, return the empty string.
    ///
    pub def dropRight(n: Int, s: Str) : Str =
        let len = length(s);
        slice(0, len - n, s)

    ///
    /// Returns the initial prefix of string `s` where all the chars satisfy
    /// the predicate `f`.
    ///
    pub def takeWhile(f: Char -> Bool, s: Str): Str =
        takeWhileHelper(f, s) |> List.toString

    ///
    /// Helper function for `takeWhile` because we seem to need an intermediate list...
    ///
    def takeWhileHelper(f: Char -> Bool, s: Str): List[Char] = match viewl(s) {
        case None => Nil
        case Some(c, s1) => if (f(c)) (c :: takeWhileHelper(f, s1)) else Nil
    }

    ///
    /// Returns the tail of string `s` after dropping all the initial chars
    /// that satisfy the predicate `f`.
    ///
    pub def dropWhile(f: Char -> Bool, s: Str): Str = match viewl(s) {
        case None => ""
        case Some(c, s1) => if (f(c)) dropWhile(f, s1) else s
    }


    ///
    /// Split the string `s` at the position `n` returning the left and
    /// right parts.
    ///
    /// If `n` exceeds the length of string `s`, return the whole string
    /// paired with the empty string.
    ///
    pub def splitAt(n: Int32, s: Str) : (Str, Str) =
        (take(n,s), drop(n,s))

    ///
    /// Deconstruct the string `s` from the left returning the first char and the rest of the string.
    ///
    /// Return None if `s` is empty.
    ///
    pub def viewl(s: Str): Option[(Char, Str)] =
        if (length(s) == 0)
            None
        else
            Some(charAt(0, s), drop(1,s))

    ///
    /// Deconstruct the string `s` from the right returning the first char and the rest of the string.
    ///
    /// Return None if `s` is empty.
    ///
    pub def viewr(s: Str): Option[(Str, Char)] = match length(s) {
        case x if x > 1  => Some(take(x-1, s), charAt(x-1, s))
        case x if x == 1 => Some("", charAt(0, s))
        case x if x < 1  => None
    }

    ///
    /// Applies `f` to a start value `x` and all elements in `s` going from left to right.
    ///
    pub def foldLeft(f: (b, Char) -> b, x: b, s: Str) : b = match viewl(s) {
        case None => x
        case Some(c,s1) =>
            let acc = f(x, c);
            foldLeft(f, acc, s1)
    }

    ///
    /// Accumulates the result of applying `f` pairwise to the elements of `s` and `t`
    /// starting with the initial value `x` and going from left to right.
    ///
    pub def foldLeft2(f: (b, Char, Char) -> b, x: b, s: Str, t: Str) : b =
        match (viewl(s), viewl(t)) {
            case (Some(a,s1), Some(b,t1)) =>
                let acc = f(x, a, b);
                foldLeft2(f, acc, s1, t1)
            case (_, _) => x
        }


    ///
    /// Applies `f` to a start value `x and all elements in `s` going from right to left.
    ///
    pub def foldRight(f: (Char, b) -> b, x: b, s: Str) : b = match viewr(s) {
        case None => x
        case Some(s1,c) =>
            let acc = f(c, x);
            foldRight(f, acc, s1)
    }

    ///
    /// Accumulates the result of applying `f` pairwise to the elements of `s` and `t`
    /// starting with the initial value `x` and going from right to left.
    ///
    pub def foldRight2(f: (Char, Char, b) -> b, x: b, s: Str, t: Str) : b =
        match (viewr(s), viewr(t)) {
            case (Some(s1, a), Some(t1, b)) =>
                let acc = f(a, b, x);
                foldRight2(f, acc, s1, t1)
            case (_, _) => x
        }

    ///
    /// Build a string from the seed value `x` applying the function `f` until `f` returns `None`.
    ///
    pub def unfold(f: b -> Option[(Char, b)], x: b) : Str =
        unfoldHelper(f, x) |> List.toString

    ///
    /// Helper function for `unfold`.
    ///
    def unfoldHelper(f: b -> Option[(Char, b)], x: b) : List[Char] = match f(x) {
        case None => Nil
        case Some(c, st1) => c :: unfoldHelper(f, st1)
    }



    ///
    /// Returns `true` if and only if at least one char in `s` satisfies the predicate `f`.
    ///
    /// Returns `false` if `a` is empty.
    ///
    pub def exists(f: Char -> Bool, s: Str): Bool = match viewl(s) {
        case None => false
        case Some(c, s1) => if (f(c)) true else exists(f, s1)
    }

    ///
    /// Returns `true` if and only if all chars in `s` satisfy the predicate `f`.
    ///
    /// Returns `true` if `s` is empty.
    ///
    pub def forall(f: Char -> Bool, s: Str): Bool = match viewl(s) {
        case None => true
        case Some(c, s1) => if (!f(c)) false else forall(f, s1)
    }

    ///
    /// Returns `true` if and only if all chars in `s` are ascii characters.
    ///
    /// Returns `true` if `s` is empty.
    ///
    pub def isAscii(s: Str): Bool =
        forall(Char.isAscii, s)

    ///
    /// Returns `true` if and only if all chars in `s` are white space characters.
    ///
    /// Returns `true` if `s` is empty.
    ///
    pub def isBlank(s: Str): Bool =
        forall(Char.isWhiteSpace, s)

    ///
    /// Returns string `s` with all leading space characters removed.
    ///
    pub def trimLeft(s: Str): Str = match viewl(s) {
        case None => ""
        case Some(c, s1) => if (!(Char.isWhiteSpace(c))) s else trimLeft(s1)
    }

    ///
    /// Returns string `s` with all trailing space characters removed.
    ///
    pub def trimRight(s: Str): Str = match viewr(s) {
        case None => ""
        case Some(s1, c) => if (!(Char.isWhiteSpace(c))) s else trimRight(s1)
    }

    ///
    /// Returns a string with the string `s` repeated `n` times.
    ///
    /// Returns the empty string if `n < 0`.
    ///
    pub def repeat(n: Int, s: Str): Str =
        if (n < 0)
            ""
        else
            native method java.lang.String.repeat(s, n) as Str

    ///
    /// Pad the string `s` at the left with the supplied char `c` to fit the width `w`.
    ///
    pub def padLeft(w: Int, c: Char, s: Str): Str =
        let x = length(s);
        if (x < w)
            repeat(w - x, Char.toString(c)) + s
        else s


    ///
    /// Pad the string `s` at the right with the supplied char `c` to fit the width `w`.
    ///
    pub def padRight(w: Int, c: Char, s: Str): Str =
        let x = length(s);
        if (x < w)
            s + repeat(w- x, Char.toString(c))
        else s


    // pub def replace(oldChar: Char, newChar: Char, s: Str): Str =
    //     native method java.lang.String.replace(s: Str, oldChar: Char, newChar: Char) as Str

    ///
    /// Returns `s` with every match of the regular expression `patt` replaced by the string `rep`.
    ///
    pub def replaceAll(patt: Str, rep: Str, s: Str): Str =
        native method java.lang.String.replaceAll(s, patt, rep) as Str

    ///
    /// Returns `s` with the first match of the regular expression `patt` replaced by the string `rep`.
    ///
    pub def replaceFirst(patt: Str, rep: Str, s: Str): Str =
        native method java.lang.String.replaceFirst(s, patt, rep) as Str

    ///
    /// Indent every line in string `s` by `n` spaces.
    ///
    /// The returned string normalizes line termination characters.
    ///
    pub def indent(n: Int, s: Str): Str =
        native method java.lang.String.indent(s, n) as Str

    ///
    /// Get the system line separator.
    ///
    pub def lineSeparator() : Str =
        native method java.lang.System.lineSeparator() as Str

    ///
    /// Split the string `s` into an array of lines on the system dependent line separator.
    ///
    pub def lines(s: Str): Array[Str] =
        split(s, lineSeparator())

    ///
    /// Join the array of strings `a` with the system dependent line
    /// separator.
    ///
    pub def unlines(a: Array[Str]): Str =
        if (Array.length(a) > 0)
            let a1 = Array.drop(1,a);
            Array.foldLeft((ac,s) -> ac + lineSeparator() + s, a[0], a1)
        else ""

    ///
    /// Split the string `s` into an array of words, dividing on one or more white space characters.
    ///
    pub def words(s: Str): Array[Str] =
        split(s, "\s+")

    ///
    /// Join the array of strings `a` with a single space character.
    ///
    pub def unwords(a: Array[Str]): Str =
        if (Array.length(a) > 0) {
            let a1 = Array.drop(1,a);
            Array.foldLeft((ac,s) -> ac + " " + s, a[0], a1)
        } else ""

    ///
    /// Alias for `indexOfLeft`.
    ///
    pub def indexOf(s: Str, sub: Str): Option[Int] = indexOfLeft(s, sub)

    ///
    /// Return the index of the first occurence of `sub` in `s` from the left.
    ///
    /// If `substring` is not present in `s` return None.
    ///
    pub def indexOfLeft(s: Str, sub: Str): Option[Int] =
        let i = native method java.lang.String.indexOf(s: Str, sub: Str) as Int;
        if (i < 0) None else Some(i)

    ///
    /// Return the index of the first occurence of `sub` in `s` from the right.
    ///
    /// If `substring` is not present in `s` return None.
    ///
    pub def indexOfRight(s: Str, sub: Str): Option[Int] =
        let i = native method java.lang.String.lastIndexOf(s: Str, sub: Str) as Int;
        if (i < 0) None else Some(i)


    ///
    /// Test if the string `s` contains `substring`.
    ///
    pub def contains(s: Str, substring: Str): Bool =
        let a = indexOfLeft(s, substring);
        !Option.isEmpty(a)

    ///
    /// Returns the reverse of `s`.
    ///
    pub def reverse(s: Str) : Str =
        let start = length(s) - 1;
        init(i -> charAt(start - i, s), start+1)


}
