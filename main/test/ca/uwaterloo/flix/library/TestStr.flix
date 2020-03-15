/////////////////////////////////////////////////////////////////////////////
// concat                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def concat01(): Bool = assertEq!("Hello World!", "Hello World!")

@test
def concat02(): Bool = assertEq!("Hello" + " World!", "Hello World!")

@test
def concat03(): Bool = assertEq!("Hello" + " World!", "Hello" + " World!")

@test
def concat04(): Bool = assertEq!("Hello World!" + "", "Hello World!")

@test
def concat05(): Bool = assertEq!("Hello" + " " + "World" + "!", "Hello World!")

@test
def concat06(): Bool =
    let f = x -> (x + " World!");
    assertEq!(f("Hello"), "Hello World!")

@test
def concat07(): Bool =
    let f = (x, y) -> (x + y);
    assertEq!(f("Hello", " World!"), "Hello World!")

@test
def concat08(): Bool =
    let f = flip((x, y) -> (x + y));
    assertEq!(f(" World!", "Hello"), "Hello World!")

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
    assert!(Char.isWhiteSpace(String.charAt(0, newline)))

@test
def lineSeparator02(): Bool =
    let newline = String.lineSeparator();
    assert!(String.length(newline) == 1 || String.length(newline) == 2)

/////////////////////////////////////////////////////////////////////////////
// charAt                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def charAt01(): Bool = assertEq!(String.charAt(0, "Hello World!"), 'H')

@test
def charAt02(): Bool = assertEq!(String.charAt(5, "Hello World!"), ' ')

/////////////////////////////////////////////////////////////////////////////
// endsWith                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def endsWith01(): Bool = assert!(String.endsWith("Hello World!", ""))

@test
def endsWith02(): Bool = assert!(String.endsWith("Hello World!", "World!"))

@test
def endsWith03(): Bool = assertNot!(String.endsWith("Hello World!", "WORLD!"))

/////////////////////////////////////////////////////////////////////////////
// startsWith                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def startsWith01(): Bool = assert!(String.startsWith("Hello World!", ""))

@test
def startsWith02(): Bool = assert!(String.startsWith("Hello World!", "Hello"))

@test
def startsWith03(): Bool = assertNot!(String.startsWith("Hello World!", "HELLO"))

/////////////////////////////////////////////////////////////////////////////
// isEmpty                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def isEmpty01(): Bool = assert!(String.isEmpty(""))

@test
def isEmpty02(): Bool = assertNot!(String.isEmpty("Hello"))


/////////////////////////////////////////////////////////////////////////////
// length                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def length01(): Bool = assertEq!(String.length(""), 0)

@test
def length02(): Bool = assertEq!(String.length("0123456789"), 10)

/////////////////////////////////////////////////////////////////////////////
// split                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def split01(): Bool & Impure =
    assertEq!(Array.toList(String.split("", "\s+")), "" :: Nil)

@test
def split02(): Bool & Impure =
    assertEq!(Array.length(String.split("1 3", "\s+")), 2)

/////////////////////////////////////////////////////////////////////////////
// toLowerCase                                                             //
/////////////////////////////////////////////////////////////////////////////
@test
def toLowerCase01(): Bool = assertEq!(String.toLowerCase(""), "")

@test
def toLowerCase02(): Bool = assertEq!(String.toLowerCase("Hello World!"), "hello world!")

@test
def toLowerCase03(): Bool = assertEq!(String.toLowerCase("→Hello World∀!"), "→hello world∀!")

/////////////////////////////////////////////////////////////////////////////
// toUpperCase                                                             //
/////////////////////////////////////////////////////////////////////////////
@test
def toUpperCase01(): Bool = assertEq!(String.toUpperCase(""), "")

@test
def toUpperCase02(): Bool = assertEq!(String.toUpperCase("Hello World!"), "HELLO WORLD!")

@test
def toUpperCase03(): Bool = assertEq!(String.toUpperCase("→Hello World∀!"), "→HELLO WORLD∀!")

/////////////////////////////////////////////////////////////////////////////
// toList                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def toList01(): Bool = assertEq!(String.toList(""), Nil)

@test
def toList02(): Bool = assertEq!(String.toList("ABC"), 'A' :: 'B' :: 'C' :: Nil)

@test
def toList03(): Bool = assertEq!(String.toList("1 2 3"), '1' :: ' ' :: '2' :: ' ' :: '3' :: Nil)

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
// left                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def left01(): Bool = String.left(-1, "") == ""

@test
def left02(): Bool = String.left(0, "") == ""

@test
def left03(): Bool = String.left(1, "") == ""

@test
def left04(): Bool = String.left(-1, "1") == ""

@test
def left05(): Bool = String.left(0, "1") == ""

@test
def left06(): Bool = String.left(1, "1") == "1"

@test
def left07(): Bool = String.left(2, "1") == "1"

@test
def left08(): Bool = String.left(0, "12") == ""

@test
def left09(): Bool = String.left(1, "12") == "1"

@test
def left10(): Bool = String.left(2, "12") == "12"

@test
def left11(): Bool = String.left(2, "123456") == "12"

@test
def left12(): Bool = String.left(4, "123456") == "1234"

@test
def left13(): Bool = String.left(10, "123456") == "123456"

/////////////////////////////////////////////////////////////////////////////
// right                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def right01(): Bool = String.right(-1, "") == ""

@test
def right02(): Bool = String.right(0, "") == ""

@test
def right03(): Bool = String.right(1, "") == ""

@test
def right04(): Bool = String.right(-1, "1") == ""

@test
def right05(): Bool = String.right(0, "1") == ""

@test
def right06(): Bool = String.right(1, "1") == "1"

@test
def right07(): Bool = String.right(2, "1") == "1"

@test
def right08(): Bool = String.right(0, "12") == ""

@test
def right09(): Bool = String.right(1, "12") == "2"

@test
def right10(): Bool = String.right(2, "12") == "12"

@test
def right11(): Bool = String.right(2, "123456") == "56"

@test
def right12(): Bool = String.right(4, "123456") == "3456"

@test
def right13(): Bool = String.right(10, "123456") == "123456"

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

