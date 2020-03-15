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
// init                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def init01(): Bool =
    String.init(_ -> 'A', 0) `assertEq!` ""

@test
def init02(): Bool =
    String.init(_ -> 'A', 2) `assertEq!` "AA"

@test
def init03(): Bool =
    String.length(String.init(_ -> '*', 50)) `assertEq!` 50

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
def take01(): Bool = String.take(-1, "") `assertEq!` ""

@test
def take02(): Bool = String.take(0, "") `assertEq!` ""

@test
def take03(): Bool = String.take(1, "") `assertEq!` ""

@test
def take04(): Bool = String.take(-1, "1") `assertEq!` ""

@test
def take05(): Bool = String.take(0, "1") `assertEq!` ""

@test
def take06(): Bool = String.take(1, "1") `assertEq!` "1"

@test
def take07(): Bool = String.take(2, "1") `assertEq!` "1"

@test
def take08(): Bool = String.take(0, "12") `assertEq!` ""

@test
def take09(): Bool = String.take(1, "12") `assertEq!` "1"

@test
def take10(): Bool = String.take(2, "12") `assertEq!` "12"

@test
def take11(): Bool = String.take(2, "123456") `assertEq!` "12"

@test
def take12(): Bool = String.take(4, "123456") `assertEq!` "1234"

@test
def take13(): Bool = String.take(10, "123456") `assertEq!` "123456"
