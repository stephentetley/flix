/*
 * Copyright 2019 Magnus Madsen, Stephen Tetley
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

namespace TestString {

/////////////////////////////////////////////////////////////////////////////
// charAt                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def charAt01(): Bool = String.charAt(0, "Hello World!") == 'H'

@test
def charAt02(): Bool = String.charAt(1, "Hello World!") == 'e'

@test
def charAt03(): Bool = String.charAt(2, "Hello World!") == 'l'

@test
def charAt04(): Bool = String.charAt(3, "Hello World!") == 'l'

@test
def charAt05(): Bool = String.charAt(4, "Hello World!") == 'o'

@test
def charAt06(): Bool = String.charAt(5, "Hello World!") == ' '

/////////////////////////////////////////////////////////////////////////////
// concat                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def concat01(): Bool = "Hello World!" == "Hello World!"

@test
def concat02(): Bool = "Hello" + " World!" == "Hello World!"

@test
def concat03(): Bool = "Hello" + " World!" == "Hello" + " World!"

@test
def concat04(): Bool = "Hello World!" + "" == "Hello World!"

@test
def concat05(): Bool = "Hello" + " " + "World" + "!" == "Hello World!"

@test
def concat06(): Bool =
    let f = x -> (x + " World!");
    f("Hello") == "Hello World!"

@test
def concat07(): Bool =
    let f = (x, y) -> (x + y);
    f("Hello", " World!") == "Hello World!"

@test
def concat08(): Bool =
    let f = flip((x, y) -> (x + y));
    f(" World!", "Hello") == "Hello World!"

/////////////////////////////////////////////////////////////////////////////
// isEmpty                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def isEmpty01(): Bool = String.isEmpty("") == true

@test
def isEmpty02(): Bool = String.isEmpty("Hello") == false

/////////////////////////////////////////////////////////////////////////////
// length                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def length01(): Bool = String.length("") == 0

@test
def length02(): Bool = String.length("0123456789") == 10

/////////////////////////////////////////////////////////////////////////////
// startsWith                                                              //
/////////////////////////////////////////////////////////////////////////////

@test
def startsWith01(): Bool = String.startsWith("Hello World!", "") == true

@test
def startsWith02(): Bool = String.startsWith("Hello World!", "Hello") == true

@test
def startsWith03(): Bool = String.startsWith("Hello World!", "HELLO") == false

/////////////////////////////////////////////////////////////////////////////
// endsWith                                                                //
/////////////////////////////////////////////////////////////////////////////

@test
def endsWith01(): Bool = String.endsWith("Hello World!", "") == true

@test
def endsWith02(): Bool = String.endsWith("Hello World!", "World!") == true

@test
def endsWith03(): Bool = String.endsWith("Hello World!", "WORLD!") == false

/////////////////////////////////////////////////////////////////////////////
// split                                                                   //
/////////////////////////////////////////////////////////////////////////////

@test
def split01(): Bool & Impure =
    Array.toList(String.split("", "\s+")) == "" :: Nil

@test
def split02(): Bool & Impure =
    Array.length(String.split("1 3", "\s+")) == 2

/////////////////////////////////////////////////////////////////////////////
// toLowerCase                                                             //
/////////////////////////////////////////////////////////////////////////////

@test
def toLowerCase01(): Bool = String.toLowerCase("") == ""

@test
def toLowerCase02(): Bool = String.toLowerCase("Hello World!") == "hello world!"

@test
def toLowerCase03(): Bool = String.toLowerCase("â†’Hello Worldâˆ€!") == "â†’hello worldâˆ€!"

/////////////////////////////////////////////////////////////////////////////
// toUpperCase                                                             //
/////////////////////////////////////////////////////////////////////////////

@test
def toUpperCase01(): Bool = String.toUpperCase("") == ""

@test
def toUpperCase02(): Bool = String.toUpperCase("Hello World!") == "HELLO WORLD!"

@test
def toUpperCase03(): Bool = String.toUpperCase("â†’Hello Worldâˆ€!") == "Â†’HELLO WORLDÂˆ€!"

/////////////////////////////////////////////////////////////////////////////
// toList                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def toList01(): Bool = String.toList("") == Nil

@test
def toList02(): Bool = String.toList("ABC") == 'A' :: 'B' :: 'C' :: Nil

@test
def toList03(): Bool = String.toList("1 2 3") == '1' :: ' ' :: '2' :: ' ' :: '3' :: Nil

/////////////////////////////////////////////////////////////////////////////
// trim                                                                    //
/////////////////////////////////////////////////////////////////////////////

@test
def trim01(): Bool = "Hello World" == String.trim("Hello World")

@test
def trim02(): Bool = "abc" == String.trim(" abc")

@test
def trim03(): Bool = "abc" == String.trim("abc ")

@test
def trim04(): Bool = "abc" == String.trim(" abc ")

@test
def trim05(): Bool = "abc" == String.trim("  abc")

@test
def trim06(): Bool = "" == String.trim("  ")

/////////////////////////////////////////////////////////////////////////////
// lineSeparator                                                           //
/////////////////////////////////////////////////////////////////////////////

@test
def lineSeparator01(): Bool =
    let newline = String.lineSeparator();
    Char.isWhiteSpace(String.charAt(0, newline)) == true

@test
def lineSeparator02(): Bool =
    let newline = String.lineSeparator();
    String.length(newline) == 1 || String.length(newline) == 2

/////////////////////////////////////////////////////////////////////////////
// toArray                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def toArray01(): Bool & Impure = Array.sameElements(String.toArray(""), []: Array[Char])

@test
def toArray02(): Bool & Impure = Array.sameElements(String.toArray("ABC"), ['A', 'B', 'C'])

@test
def toArray03(): Bool & Impure = Array.sameElements(String.toArray("1 2 3"), ['1', ' ', '2', ' ', '3'])

/////////////////////////////////////////////////////////////////////////////
// init                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def init01(): Bool = String.init(_ -> 'A', 0) == ""

@test
def init02(): Bool = String.init(_ -> 'A', -1) == ""

@test
def init03(): Bool = String.init(_ -> 'A', 1) == "A"

@test
def init04(): Bool = String.init(_ -> 'A', 2) == "AA"

@test
def init05(): Bool =
    let s = String.init(_ -> 'A', 50);
    String.length(s) == 50

/////////////////////////////////////////////////////////////////////////////
// flatten                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def flatten01(): Bool = String.flatten(Nil) == ""

@test
def flatten02(): Bool = String.flatten("" :: Nil) == ""

@test
def flatten03(): Bool = String.flatten("a" :: Nil) == "a"

@test
def flatten04(): Bool = String.flatten("ab" :: Nil) == "ab"

@test
def flatten05(): Bool = String.flatten("" :: "" :: Nil) == ""

@test
def flatten06(): Bool = String.flatten("a" :: "" :: Nil) == "a"

@test
def flatten07(): Bool = String.flatten("" :: "a" :: Nil) == "a"

@test
def flatten08(): Bool = String.flatten("a" :: "b" :: Nil) == "ab"

@test
def flatten09(): Bool = String.flatten("ab" :: "cde" :: Nil) == "abcde"

@test
def flatten10(): Bool = String.flatten("a" :: "bc" :: "d" :: Nil) == "abcd"

/////////////////////////////////////////////////////////////////////////////
// flattenWithSep                                                          //
/////////////////////////////////////////////////////////////////////////////
@test
def flattenWithSep01(): Bool = String.flattenWithSep("-", Nil) == ""

@test
def flattenWithSep02(): Bool = String.flattenWithSep("-", "" :: Nil) == ""

@test
def flattenWithSep03(): Bool = String.flattenWithSep("-", "a" :: Nil) == "a"

@test
def flattenWithSep04(): Bool = String.flattenWithSep("-", "ab" :: Nil) == "ab"

@test
def flattenWithSep05(): Bool = String.flattenWithSep("-", "" :: "" :: Nil) == "-"

@test
def flattenWithSep06(): Bool = String.flattenWithSep("-", "a" :: "" :: Nil) == "a-"

@test
def flattenWithSep07(): Bool = String.flattenWithSep("-", "" :: "a" :: Nil) == "-a"

@test
def flattenWithSep08(): Bool = String.flattenWithSep("-", "a" :: "b" :: Nil) == "a-b"

@test
def flattenWithSep09(): Bool = String.flattenWithSep("-", "ab" :: "cde" :: Nil) == "ab-cde"

@test
def flattenWithSep10(): Bool = String.flattenWithSep("-", "a" :: "bc" :: "d" :: Nil) == "a-bc-d"

@test
def flattenWithSep11(): Bool = String.flattenWithSep("", "a" :: "bc" :: "d" :: Nil) == "abcd"

@test
def flattenWithSep12(): Bool = String.flattenWithSep("<>", "a" :: "bc" :: "d" :: Nil) == "a<>bc<>d"

/////////////////////////////////////////////////////////////////////////////
// flattenWithSepChar                                                      //
/////////////////////////////////////////////////////////////////////////////
@test
def flattenWithSepChar01(): Bool = String.flattenWithSepChar('-', Nil) == ""

@test
def flattenWithSepChar02(): Bool = String.flattenWithSepChar('-', "" :: Nil) == ""

@test
def flattenWithSepChar03(): Bool = String.flattenWithSepChar('-', "a" :: Nil) == "a"

@test
def flattenWithSepChar04(): Bool = String.flattenWithSepChar('-', "ab" :: Nil) == "ab"

@test
def flattenWithSepChar05(): Bool = String.flattenWithSepChar('-', "" :: "" :: Nil) == "-"

@test
def flattenWithSepChar06(): Bool = String.flattenWithSepChar('-', "a" :: "" :: Nil) == "a-"

@test
def flattenWithSepChar07(): Bool = String.flattenWithSepChar('-', "" :: "a" :: Nil) == "-a"

@test
def flattenWithSepChar08(): Bool = String.flattenWithSepChar('-', "a" :: "b" :: Nil) == "a-b"

@test
def flattenWithSepChar09(): Bool = String.flattenWithSepChar('-', "ab" :: "cde" :: Nil) == "ab-cde"

@test
def flattenWithSepChar10(): Bool = String.flattenWithSepChar('-', "a" :: "bc" :: "d" :: Nil) == "a-bc-d"

@test
def flattenWithSepChar11(): Bool = String.flattenWithSepChar(' ', "a" :: "bc" :: "d" :: Nil) == "a bc d"

@test
def flattenWithSepChar12(): Bool = String.flattenWithSepChar('/', "a" :: "bc" :: "d" :: Nil) == "a/bc/d"

/////////////////////////////////////////////////////////////////////////////
// map                                                                     //
/////////////////////////////////////////////////////////////////////////////
@test
def map01(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "") == ""

@test
def map02(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "a") == "f"

@test
def map03(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "A") == "t"

@test
def map04(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "ab") == "ff"

@test
def map05(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "aB") == "ft"

@test
def map06(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "Ab") == "tf"

@test
def map07(): Bool = String.map(c -> if (Char.isUpperCase(c)) 't' else 'f', "AB") == "tt"

/////////////////////////////////////////////////////////////////////////////
// mapWithIndex                                                            //
/////////////////////////////////////////////////////////////////////////////
@test
def mapWithIndex01(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "") == ""

@test
def mapWithIndex02(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "a") == "f"

@test
def mapWithIndex03(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "A") == "t"

@test
def mapWithIndex04(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "aB") == "fT"

@test
def mapWithIndex05(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "ab") == "fF"

@test
def mapWithIndex06(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "AB") == "tT"

@test
def mapWithIndex07(): Bool =
    let test = (c,i) -> if (i < 1) { if (Char.isUpperCase(c)) 't' else 'f' } else { if (Char.isUpperCase(c)) 'T' else 'F' };
    String.mapWithIndex(test, "Ab") == "tF"

/////////////////////////////////////////////////////////////////////////////
// map2                                                                    //
/////////////////////////////////////////////////////////////////////////////

@test
def map201(): Bool =
    let s = String.map2((a, b) -> if (Char.isLowerCase(a)) a else b, "", "");
    s == ""

@test
def map202(): Bool =
    let s = String.map2((a, b) -> if (Char.isLowerCase(a)) a else b, "a", "");
    s == ""

@test
def map203(): Bool =
    let s = String.map2((a, b) -> if (Char.isLowerCase(a)) a else b, "", "1");
    s == ""

@test
def map204(): Bool =
    let s = String.map2((a, b) -> if (Char.isLowerCase(a)) a else b, "A", "1");
    s == "1"

@test
def map205(): Bool =
    let s = String.map2((a, b) -> if (Char.isLowerCase(a)) a else b, "a", "1");
    s == "a"

@test
def map206(): Bool =
    let s = String.map2((a, b) -> if (Char.isLowerCase(a)) a else b, "_bc__fgh", "12345678");
    s == "1bc45fgh"

/////////////////////////////////////////////////////////////////////////////
// reverse                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def reverse01(): Bool =
    String.reverse("") == ""

@test
def reverse02(): Bool =
    String.reverse("A") == "A"

@test
def reverse03(): Bool =
    String.reverse("Hello World") == "dlroW olleH"

@test
def reverse04(): Bool =
    String.reverse("Hello World!") == "!dlroW olleH"

@test
def reverse05(): Bool =
    String.reverse("Hello World!") != "!dlroW OLLEH"

/////////////////////////////////////////////////////////////////////////////
// rotateLeft                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def rotateLeft01(): Bool = String.rotateLeft(0, "") == ""

@test
def rotateLeft02(): Bool = String.rotateLeft(1, "") == ""

@test
def rotateLeft03(): Bool = String.rotateLeft(0, "a") == "a"

@test
def rotateLeft04(): Bool = String.rotateLeft(0, "ab") == "ab"

@test
def rotateLeft05(): Bool = String.rotateLeft(1, "ab") == "ba"

@test
def rotateLeft06(): Bool = String.rotateLeft(2, "ab") == "ab"

@test
def rotateLeft07(): Bool = String.rotateLeft(3, "ab") == "ba"

@test
def rotateLeft08(): Bool = String.rotateLeft(-1, "ab") == "ba"

@test
def rotateLeft09(): Bool = String.rotateLeft(0, "abc") == "abc"

@test
def rotateLeft10(): Bool = String.rotateLeft(1, "abc") == "bca"

@test
def rotateLeft11(): Bool = String.rotateLeft(2, "abc") == "cab"

/////////////////////////////////////////////////////////////////////////////
// rotateRight                                                             //
/////////////////////////////////////////////////////////////////////////////
@test
def rotateRight01(): Bool = String.rotateRight(0, "") == ""

@test
def rotateRight02(): Bool = String.rotateRight(1, "") == ""

@test
def rotateRight03(): Bool = String.rotateRight(0, "a") == "a"

@test
def rotateRight04(): Bool = String.rotateRight(0, "ab") == "ab"

@test
def rotateRight05(): Bool = String.rotateRight(1, "ab") == "ba"

@test
def rotateRight06(): Bool = String.rotateRight(2, "ab") == "ab"

@test
def rotateRight07(): Bool = String.rotateRight(3, "ab") == "ba"

@test
def rotateRight08(): Bool = String.rotateRight(-1, "ab") == "ba"

@test
def rotateRight09(): Bool = String.rotateRight(0, "abc") == "abc"

@test
def rotateRight10(): Bool = String.rotateRight(1, "abc") == "cab"

@test
def rotateRight11(): Bool = String.rotateRight(2, "abc") == "bca"

/////////////////////////////////////////////////////////////////////////////
// isMatch                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def isMatch01(): Bool = String.isMatch(".*", "") == true

@test
def isMatch02(): Bool = String.isMatch(".+", "") == false

@test
def isMatch03(): Bool = String.isMatch("[a]*", "") == true

@test
def isMatch04(): Bool = String.isMatch("[a]+", "") == false

@test
def isMatch05(): Bool = String.isMatch("[a]*", "a") == true

@test
def isMatch06(): Bool = String.isMatch("[a]*", "aa") == true

@test
def isMatch07(): Bool = String.isMatch("[a]*", "aab") == false

@test
def isMatch08(): Bool = String.isMatch("[a]*b", "aab") == true

@test
def isSMatch09(): Bool = String.isMatch("[b]+", "aab") == false

@test
def isMatch10(): Bool = String.isMatch("[b]+", "bbbc") == false

@test
def isMatch11(): Bool = String.isMatch("[b]+", "aabbbc") == false

/////////////////////////////////////////////////////////////////////////////
// isSubmatch                                                              //
/////////////////////////////////////////////////////////////////////////////

@test
def isSubmatch01(): Bool = String.isSubmatch(".*", "") == true

@test
def isSubmatch02(): Bool = String.isSubmatch(".+", "") == false

@test
def isSubmatch03(): Bool = String.isSubmatch("[a]*", "") == true

@test
def isSubmatch04(): Bool = String.isSubmatch("[a]+", "") == false

@test
def isSubmatch05(): Bool = String.isSubmatch("[a]*", "a") == true

@test
def isSubmatch06(): Bool = String.isSubmatch("[a]*", "aa") == true

@test
def isSubmatch07(): Bool = String.isSubmatch("[a]*", "aab") == true

@test
def isSubmatch08(): Bool = String.isSubmatch("[a]*b", "aab") == true

@test
def isSubmatch09(): Bool = String.isSubmatch("[b]+", "aab") == true

@test
def isSubmatch10(): Bool = String.isSubmatch("[b]+", "bbbc") == true

@test
def isSubmatch11(): Bool = String.isSubmatch("[b]+", "aabbbc") == true

/////////////////////////////////////////////////////////////////////////////
// hashCode                                                                //
/////////////////////////////////////////////////////////////////////////////

@test
def hashCode01(): Bool = String.hashCode("") == 0

@test
def hashCode02(): Bool = String.hashCode("a") == String.hashCode("a")

@test
def hashCode03(): Bool = String.hashCode("ab") == String.hashCode("ab")

@test
def hashCode04(): Bool = String.hashCode("a") < String.hashCode("ab")

@test
def hashCode05(): Bool = String.hashCode("abc") == String.hashCode("abc")

@test
def hashCode06(): Bool = String.hashCode("ab") < String.hashCode("abc")

/////////////////////////////////////////////////////////////////////////////
// slice                                                                   //
/////////////////////////////////////////////////////////////////////////////

@test
def slice01(): Bool = String.slice("", 0, 1) == ""

@test
def slice02(): Bool = String.slice("a", 0, 1) == "a"

@test
def slice03(): Bool = String.slice("a", 1, 2) == ""

@test
def slice04(): Bool = String.slice("a", 0, 2) == ""

@test
def slice05(): Bool = String.slice("a", -1, 0) == ""

@test
def slice06(): Bool = String.slice("ab", 0, 1) == "a"

@test
def slice07(): Bool = String.slice("ab", 1, 2) == "b"

@test
def slice08(): Bool = String.slice("ab", 0, 2) == "ab"

@test
def slice09(): Bool = String.slice("ab", 0, 3) == ""

@test
def slice10(): Bool = String.slice("ab", -1, 2) == ""

@test
def slice11(): Bool = String.slice("abc", 0, 1) == "a"

@test
def slice12(): Bool = String.slice("abc", 1, 2) == "b"

@test
def slice13(): Bool = String.slice("abc", 2, 3) == "c"

@test
def slice14(): Bool = String.slice("abc", 0, 2) == "ab"

@test
def slice15(): Bool = String.slice("abc", 1, 3) == "bc"

@test
def slice16(): Bool = String.slice("abc", 0, 3) == "abc"

/////////////////////////////////////////////////////////////////////////////
// sliceLeft                                                               //
/////////////////////////////////////////////////////////////////////////////

@test
def sliceLeft01(): Bool = String.sliceLeft("", 0) == ""

@test
def sliceLeft02(): Bool = String.sliceLeft("", 1) == ""

@test
def sliceLeft03(): Bool = String.sliceLeft("a", 1) == "a"

@test
def sliceLeft04(): Bool = String.sliceLeft("a", 0) == ""

@test
def sliceLeft05(): Bool = String.sliceLeft("a", 2) == ""

@test
def sliceLeft06(): Bool = String.sliceLeft("ab", 1) == "a"

@test
def sliceLeft07(): Bool = String.sliceLeft("ab", 2) == "ab"

@test
def sliceLeft08(): Bool = String.sliceLeft("ab", 0) == ""

@test
def sliceLeft09(): Bool = String.sliceLeft("ab", 3) == ""

@test
def sliceLeft10(): Bool = String.sliceLeft("ab", -1) == ""

@test
def sliceLeft11(): Bool = String.sliceLeft("abc", 1) == "a"

@test
def sliceLeft12(): Bool = String.sliceLeft("abc", 2) == "ab"

@test
def sliceLeft13(): Bool = String.sliceLeft("abc", 3) == "abc"

@test
def sliceLeft14(): Bool = String.sliceLeft("abc", 0) == ""

@test
def sliceLeft15(): Bool = String.sliceLeft("abc", 4) == ""

@test
def sliceLeft16(): Bool = String.sliceLeft("abc", -1) == ""

/////////////////////////////////////////////////////////////////////////////
// sliceRight                                                              //
/////////////////////////////////////////////////////////////////////////////

@test
def sliceRight01(): Bool = String.sliceRight("", 0) == ""

@test
def sliceRight02(): Bool = String.sliceRight("", 1) == ""

@test
def sliceRight03(): Bool = String.sliceRight("a", 1) == ""

@test
def sliceRight04(): Bool = String.sliceRight("a", 0) == ""

@test
def sliceRight05(): Bool = String.sliceRight("a", 1) == ""

@test
def sliceRight06(): Bool = String.sliceRight("ab", 0) == "b"

@test
def sliceRight07(): Bool = String.sliceRight("ab", 1) == ""

@test
def sliceRight08(): Bool = String.sliceRight("ab", -1) == ""

@test
def sliceRight09(): Bool = String.sliceRight("ab", 2) == ""

@test
def sliceRight10(): Bool = String.sliceRight("abc", 0) == "bc"

@test
def sliceRight11(): Bool = String.sliceRight("abc", 1) == "c"

@test
def sliceRight12(): Bool = String.sliceRight("abc", 2) == ""

@test
def sliceRight13(): Bool = String.sliceRight("abc", 3) == ""

@test
def sliceRight14(): Bool = String.sliceRight("abc", -1) == ""

/////////////////////////////////////////////////////////////////////////////
// findIndices                                                             //
/////////////////////////////////////////////////////////////////////////////

@test
def findIndices01(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "");
    Array.sameElements(a, []: Array[Int32])

@test
def findIndices02(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "a");
    Array.sameElements(a, []: Array[Int32])

@test
def findIndices03(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "1");
    Array.sameElements(a, [0])

@test
def findIndices04(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "ab");
    Array.sameElements(a, [] : Array[Int32])

@test
def findIndices05(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "1b");
    Array.sameElements(a, [0])

@test
def findIndices06(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "a2");
    Array.sameElements(a, [1])

@test
def findIndices07(): Bool & Impure =
    let a = String.findIndices(Char.isDigit, "12");
    Array.sameElements(a, [0,1])

/////////////////////////////////////////////////////////////////////////////
// indices                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def indices01(): Bool & Impure =
    let a = String.indices('a', "b");
    Array.sameElements(a, []: Array[Int32])

@test
def indices02(): Bool & Impure =
    let a = String.indices('a', "b");
    Array.sameElements(a, []: Array[Int32])

@test
def indices03(): Bool & Impure =
    let a = String.indices('a', "a");
    Array.sameElements(a, [0])

@test
def indices04(): Bool & Impure =
    let a = String.indices('a', "bc");
    Array.sameElements(a, []: Array[Int32])

@test
def indices05(): Bool & Impure =
    let a = String.indices('a', "ab");
    Array.sameElements(a, [0])

@test
def indices06(): Bool & Impure =
    let a = String.indices('b', "ab");
    Array.sameElements(a, [1])

@test
def indices07(): Bool & Impure =
    let a = String.indices('a', "aa");
    Array.sameElements(a, [0,1])

/////////////////////////////////////////////////////////////////////////////
// take                                                                    //
/////////////////////////////////////////////////////////////////////////////

@test
def take01(): Bool = String.take(-1, "") == ""

@test
def take02(): Bool = String.take(0, "") == ""

@test
def take03(): Bool = String.take(1, "") == ""

@test
def take04(): Bool = String.take(-1, "1") == ""

@test
def take05(): Bool = String.take(0, "1") == ""

@test
def take06(): Bool = String.take(1, "1") == "1"

@test
def take07(): Bool = String.take(2, "1") == "1"

@test
def take08(): Bool = String.take(0, "12") == ""

@test
def take09(): Bool = String.take(1, "12") == "1"

@test
def take10(): Bool = String.take(2, "12") == "12"

@test
def take11(): Bool = String.take(2, "123456") == "12"

@test
def take12(): Bool = String.take(4, "123456") == "1234"

@test
def take13(): Bool = String.take(10, "123456") == "123456"

/////////////////////////////////////////////////////////////////////////////
// patch                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def patch01(): Bool = String.patch(0, 0, "", "") == ""

@test
def patch02(): Bool = String.patch(0, 2, "ab", "") == ""

@test
def patch03(): Bool = String.patch(0, 2, "", "ab") == "ab"

@test
def patch04(): Bool = String.patch(-3, 3, "abd", "ab") == "ab"

@test
def patch05(): Bool = String.patch(2, 3, "abd", "ab") == "ab"

@test
def patch06(): Bool = String.patch(0, 0, "", "a") == "a"

@test
def patch07(): Bool = String.patch(1, 0, "b", "a") == "a"

@test
def patch08(): Bool = String.patch(0, 1, "b", "a") == "b"

@test
def patch09(): Bool = String.patch(0, 2, "bd", "a") == "b"

@test
def patch10(): Bool = String.patch(-1, 2, "bd", "a") == "d"

@test
def patch11(): Bool = String.patch(-1, 2, "cd", "ab") == "db"

@test
def patch12(): Bool = String.patch(1, 2, "cd", "ab") == "ac"

@test
def patch13(): Bool = String.patch(-2, 2, "cd", "ab") == "ab"

@test
def patch14(): Bool = String.patch(2, 2, "cd", "ab") == "ab"

@test
def patch15(): Bool = String.patch(1, 1, "c", "ab") == "ac"

@test
def patch16(): Bool = String.patch(0, 2, "cd", "ab") == "cd"

@test
def patch17(): Bool = String.patch(0, 1, "d", "abc") == "dbc"

@test
def patch18(): Bool = String.patch(1, 1, "d", "abc") == "adc"

@test
def patch19(): Bool = String.patch(2, 1, "d", "abc") == "abd"

@test
def patch20(): Bool = String.patch(0, 2, "de", "abc") == "dec"

@test
def patch21(): Bool = String.patch(1, 2, "de", "abc") == "ade"

@test
def patch22(): Bool = String.patch(0, 2, "def", "abc") == "dec"

@test
def patch23(): Bool = String.patch(0, 3, "def", "abc") == "def"

@test
def patch24(): Bool = String.patch(2, 4, "nopq", "abcdefg") == "abnopqg"

@test
def patch25(): Bool = String.patch(-2, 4, "nopq", "abcdefg") == "pqcdefg"

@test
def patch26(): Bool = String.patch(4, 5, "nopq", "abcdefg") == "abcdnop"

@test
def patch27(): Bool = String.patch(4, 2, "nopq", "abcdefg") == "abcdnog"

@test
def patch28(): Bool = String.patch(-1, 10, "ABCDEFGH", "abcdefg") == "BCDEFGH"

/////////////////////////////////////////////////////////////////////////////
// commonPrefix                                                            //
/////////////////////////////////////////////////////////////////////////////

@test
def commonPrefix01(): Bool =
    String.commonPrefix("", "") == ""

@test
def commonPrefix02(): Bool =
    String.commonPrefix("a", "") == ""

@test
def commonPrefix03(): Bool =
    String.commonPrefix("", "a") == ""

@test
def commonPrefix04(): Bool =
    String.commonPrefix("a", "a") == "a"

@test
def commonPrefix05(): Bool =
    String.commonPrefix("a", "b") == ""

@test
def commonPrefix06(): Bool =
    String.commonPrefix("ab", "bc") == ""

@test
def commonPrefix07(): Bool =
    String.commonPrefix("ab", "ac") == "a"

@test
def commonPrefix08(): Bool =
    String.commonPrefix("ab", "ab") == "ab"

@test
def commonPrefix09(): Bool =
    String.commonPrefix("abc", "ABC") == ""

@test
def commonPrefix10(): Bool =
    String.commonPrefix("abc", "abcd") == "abc"

@test
def commonPrefix11(): Bool =
    String.commonPrefix("abcd", "abc") == "abc"

/////////////////////////////////////////////////////////////////////////////
// commonSuffix                                                            //
/////////////////////////////////////////////////////////////////////////////

@test
def commonSuffix01(): Bool =
    String.commonSuffix("", "") == ""

@test
def commonSuffix02(): Bool =
    String.commonSuffix("a", "") == ""

@test
def commonSuffix03(): Bool =
    String.commonSuffix("", "a") == ""

@test
def commonSuffix04(): Bool =
    String.commonSuffix("a", "a") == "a"

@test
def commonSuffix05(): Bool =
    String.commonSuffix("a", "b") == ""

@test
def commonSuffix06(): Bool =
    String.commonSuffix("ab", "bc") == ""

@test
def commonSuffix07(): Bool =
    String.commonSuffix("ab", "_b") == "b"

@test
def commonSuffix08(): Bool =
    String.commonSuffix("ab", "ab") == "ab"

@test
def commonSuffix09(): Bool =
    String.commonSuffix("abc", "ABC") == ""

@test
def commonSuffix10(): Bool =
    String.commonSuffix("bcd", "abcd") == "bcd"

@test
def commonSuffix11(): Bool =
    String.commonSuffix("abcd", "bcd") == "bcd"

/////////////////////////////////////////////////////////////////////////////
// abbreviateLeft                                                          //
/////////////////////////////////////////////////////////////////////////////

@test
def abbreviateLeft01(): Bool =
    String.abbreviateLeft(0, "") == ""

@test
def abbreviateLeft02(): Bool =
    String.abbreviateLeft(0, "a") == ""

@test
def abbreviateLeft03(): Bool =
    String.abbreviateLeft(0, "abcde") == ""

@test
def abbreviateLeft04(): Bool =
    String.abbreviateLeft(1, "") == ""

@test
def abbreviateLeft05(): Bool =
    String.abbreviateLeft(1, "a") == ""

@test
def abbreviateLeft06(): Bool =
    String.abbreviateLeft(1, "abcde") == ""

@test
def abbreviateLeft07(): Bool =
    String.abbreviateLeft(3, "") == ""

@test
def abbreviateLeft08(): Bool =
    String.abbreviateLeft(3, "a") == "a"

@test
def abbreviateLeft09(): Bool =
    String.abbreviateLeft(3, "abcde") == "..."

@test
def abbreviateLeft10(): Bool =
    String.abbreviateLeft(4, "") == ""

@test
def abbreviateLeft11(): Bool =
    String.abbreviateLeft(4, "a") == "a"

@test
def abbreviateLeft12(): Bool =
    String.abbreviateLeft(4, "abcde") == "...e"

@test
def abbreviateLeft13(): Bool =
    String.abbreviateLeft(5, "") == ""

@test
def abbreviateLeft14(): Bool =
    String.abbreviateLeft(5, "a") == "a"

@test
def abbreviateLeft15(): Bool =
    String.abbreviateLeft(5, "abcde") == "...de"


/////////////////////////////////////////////////////////////////////////////
// abbreviateRight                                                         //
/////////////////////////////////////////////////////////////////////////////

@test
def abbreviateRight01(): Bool =
    String.abbreviateRight(0, "") == ""

@test
def abbreviateRight02(): Bool =
    String.abbreviateRight(0, "a") == ""

@test
def abbreviateRight03(): Bool =
    String.abbreviateRight(0, "abcde") == ""

@test
def abbreviateRight04(): Bool =
    String.abbreviateRight(1, "") == ""

@test
def abbreviateRight05(): Bool =
    String.abbreviateRight(1, "a") == ""

@test
def abbreviateRight06(): Bool =
    String.abbreviateRight(1, "abcde") == ""

@test
def abbreviateRight07(): Bool =
    String.abbreviateRight(3, "") == ""

@test
def abbreviateRight08(): Bool =
    String.abbreviateRight(3, "a") == "a"

@test
def abbreviateRight09(): Bool =
    String.abbreviateRight(3, "abcde") == "..."

@test
def abbreviateRight10(): Bool =
    String.abbreviateRight(4, "") == ""

@test
def abbreviateRight11(): Bool =
    String.abbreviateRight(4, "a") == "a"

@test
def abbreviateRight12(): Bool =
    String.abbreviateRight(4, "abcde") == "a..."

@test
def abbreviateRight13(): Bool =
    String.abbreviateRight(5, "") == ""

@test
def abbreviateRight14(): Bool =
    String.abbreviateRight(5, "a") == "a"

@test
def abbreviateRight15(): Bool =
    String.abbreviateRight(5, "abcde") == "ab..."

/////////////////////////////////////////////////////////////////////////////
// levenshteinDistance                                                     //
/////////////////////////////////////////////////////////////////////////////

@test
def levenshteinDistance01(): Bool =
    String.levenshteinDistance("", "") == 0

@test
def levenshteinDistance02(): Bool =
    String.levenshteinDistance("A", "") == 1

@test
def levenshteinDistance03(): Bool =
    String.levenshteinDistance("", "A") == 1

@test
def levenshteinDistance04(): Bool =
    String.levenshteinDistance("A", "A") == 0

@test
def levenshteinDistance05(): Bool =
    String.levenshteinDistance("kitten", "sitting") == 3

@test
def levenshteinDistance06(): Bool =
    String.levenshteinDistance("Saturday", "Sunday") == 3

@test
def levenshteinDistance07(): Bool =
    String.levenshteinDistance("Gumbo", "Gambol") == 2


/////////////////////////////////////////////////////////////////////////////
// equalsCI                                                                //
/////////////////////////////////////////////////////////////////////////////

@test
def equalsCI01(): Bool =
    String.equalsCI("", "") == true

@test
def equalsCI02(): Bool =
    String.equalsCI("Hello World", "") == false

@test
def equalsCI03(): Bool =
    String.equalsCI("", "Hello World") == false

@test
def equalsCI04(): Bool =
    String.equalsCI("Hello World", "Hello World") == true

@test
def equalsCI05(): Bool =
    String.equalsCI("Hello World", "HELLO WORLD") == true

@test
def equalsCI06(): Bool =
    String.equalsCI("Hello World", "hello world") == true

@test
def equalsCI07(): Bool =
    String.equalsCI("Hello World", "hELLO wORLD") == true

@test
def equalsCI08(): Bool =
    String.equalsCI("hello world", "HELLO WORLD") == true

@test
def equalsCI09(): Bool =
    String.equalsCI("hello world", "HELLO WORLD!") == false

/////////////////////////////////////////////////////////////////////////////
// zip                                                                     //
/////////////////////////////////////////////////////////////////////////////

@test
def zip01(): Bool & Impure =
    let a = String.zip("", "");
    Array.sameElements(a, []: Array[(Char,Char)])

@test
def zip02(): Bool & Impure =
    let a = String.zip("a", "");
    Array.sameElements(a, []: Array[(Char, Char)])

@test
def zip03(): Bool & Impure =
    let a = String.zip("", "1");
    Array.sameElements(a, []: Array[(Char, Char)])

@test
def zip04(): Bool & Impure =
    let a = String.zip("a", "1");
    Array.sameElements(a, [('a', '1')])

@test
def zip05(): Bool & Impure =
    let a = String.zip("ab", "12");
    Array.sameElements(a, [('a', '1'), ('b', '2')])

@test
def zip06(): Bool & Impure =
    let a = String.zip("abc", "123");
    Array.sameElements(a, [('a', '1'), ('b', '2'), ('c', '3')])

@test
def zip07(): Bool & Impure =
    let a = String.zip("abcd", "1234");
    Array.sameElements(a, [('a', '1'), ('b', '2'), ('c', '3'), ('d', '4')])

/////////////////////////////////////////////////////////////////////////////
// zipWith                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def zipWith01(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "", "");
    s == ""

@test
def zipWith02(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "a", "");
    s == ""

@test
def zipWith03(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "", "1");
    s == ""

@test
def zipWith04(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "_", "1");
    s == "1"

@test
def zipWith05(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "a", "1");
    s == "a"

@test
def zipWith06(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "_bc__fgh", "12345678");
    s == "1bc45fgh"

@test
def zipWith07(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "_bc__fghijkl", "12345678");
    s == "1bc45fgh"

@test
def zipWith08(): Bool =
    let s = String.zipWith((a, b) -> if (Char.isLetter(a)) a else b, "_bc__fgh", "1234567890");
    s == "1bc45fgh"

}