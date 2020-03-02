/*
 * Copyright 2019 Magnus Madsen
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

namespace Array {

    ///
    /// Returns a fresh array of length `l` filled with the element `x`.
    ///
    /// Equivalent to the expression `[x; l]`.
    ///
    pub def new(x: a, l: Int): Array[a] & Impure = [x; l]

    ///
    /// Returns the element at position `i` in the array `a`.
    ///
    /// Equivalent to the expression `a[i]`.
    ///
    pub def get(a: Array[a], i: Int): a & Impure = a[i]

    ///
    /// Stores the value `x` at position `i` in the array `a`.
    ///
    /// Equivalent to the expression `a[i] = x`.
    ///
    pub def put(a: Array[a], i: Int, x: a): Array[a] & Impure = a[i] = x; a

    ///
    /// Returns the length of the array `a`.
    ///
    pub def length(a: Array[a]): Int = a.length

    ///
    /// Returns a fresh array with the elements from the array `a` from index `b` (inclusive) until index `e` (exclusive).
    ///
    /// Equivalent to the expression `a[b..e]`.
    ///
    pub def slice(a: Array[a], b: Int, e: Int): Array[a] & Impure = a[b..e]

    ///
    /// Returns the array `a` as a list.
    ///
    pub def toList(a: Array[a]): List[a] & Impure = toListHelper(a, 0)

    ///
    /// Helper for toList.
    ///
    def toListHelper(a: Array[a], i: Int): List[a] & Impure =
        if (i == length(a))
            Nil
        else
            a[i] :: toListHelper(a, i + 1)


    ///
    /// Build an array of length `len` by applying `f` to the successive indices.
    ///
    pub def init(f: Int32 -> a & e, len: Int32): Array[a] & Impure =
        if (len <= 0)
            []
        else {
            let x = f(0);
            let a = new(x, len);
            initHelper(a, f, len, 1);
            a
        }

    ///
    /// Helper function for `init`.
    ///
    def initHelper(a: Array[a], f: i -> a & e, len: Int32, i: Int32): Unit & Impure =
        if (i >= len)
            ()
        else {
            a[i] = f(i);
            initHelper(a, f, len, i+1)
        }

    ///
    /// Applies `f` to a start value `s` and all elements in `a` going from left to right.
    ///
    /// That is, the result is of the form: `f(...f(f(s, a[0]), a[1])..., xn)`.
    ///
    pub def foldLeft(f: (b, a) -> b & e, s: b, a: Array[a]): b & e =
        foldLeftHelper(f, s, a, 0)

    ///
    /// Helper function for `foldLeft`.
    ///
    def foldLeftHelper(f: (b, a) -> b & e, s: b, a: Array[a], i: Int): b & e =
        if (i >= length(a))
            s
        else {
            let s1 = f(s, a[i] as a & e);
            foldLeftHelper(f, s1, a, i + 1)
        }

    ///
    /// Render the array `a` as a String. Elements are rendered with the
    /// function `f` and seperated with the string `sep`.
    ///
    pub def mkStringBy(f: a -> String & e, sep: String, a: Array[a]): String & Impure =
        let sb = StringBuilder.new();
        let step = (x,i) ->
            if (i == 0)
                StringBuilder.appendString(sb, f(x))
            else {
                StringBuilder.appendString(sb, sep);
                StringBuilder.appendString(sb, f(x))
            };
        foreachWithIndex(step, a);
        StringBuilder.toString(sb)

    ///
    /// Apply the effectful function `f` to all the elements in the array `a`.
    ///
    pub def foreachWithIndex(f: (a, Int32) ~> Unit, a: Array[a]): Unit & Impure =
        let len = length(a);
        if (len < 1) () else foreachWithIndexHelper(f, a, len, 0)

    ///
    /// Helper for `foreachWithIndex`.
    ///
    def foreachWithIndexHelper(f: (a, Int32) ~> Unit, a: Array[a], len: Int32, i: Int32): Unit & Impure =
        if (i >= len)
            ()
        else {
            f(a[i], i);
            foreachWithIndexHelper(f, a, len, i + 1)
        }

}
