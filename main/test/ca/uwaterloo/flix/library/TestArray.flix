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
@test
def testNew01(): Bool = Array.new(42, 10)[0] == 42

@test
def testNew02(): Bool = Array.new(42, 10)[5] == 42

@test
def testNew03(): Bool = Array.new(42, 10)[9] == 42

@test
def testGet01(): Bool = Array.get([1, 2, 3], 0) == 1

@test
def testGet02(): Bool = Array.get([1, 2, 3], 1) == 2

@test
def testGet03(): Bool = Array.get([1, 2, 3], 2) == 3

@test
def testPut01(): Bool = Array.put([1], 0, 42)[0] == 42

@test
def testPut02(): Bool = Array.put([1, 2], 1, 42)[1] == 42

@test
def testPut03(): Bool = Array.put([1, 2, 3], 2, 42)[2] == 42

@test
def testLength01(): Bool = Array.length([]) == 0

@test
def testLength02(): Bool = Array.length([1]) == 1

@test
def testLength03(): Bool = Array.length([1, 2, 3]) == 3

/////////////////////////////////////////////////////////////////////////////
// slice                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def testSlice01(): Bool = Array.slice([1, 2, 3], 0, 1)[0] == 1

@test
def testSlice02(): Bool = Array.slice([1, 2, 3], 1, 2)[0] == 2

@test
def testSlice03(): Bool = Array.slice([1, 2, 3], 2, 3)[0] == 3

/////////////////////////////////////////////////////////////////////////////
// toList                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def testToList01(): Bool = Array.toList([]) == Nil

@test
def testToList02(): Bool = Array.toList([1]) == 1 :: Nil

@test
def testToList03(): Bool = Array.toList([1, 2]) == 1 :: 2 :: Nil

/////////////////////////////////////////////////////////////////////////////
// init                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def init01(): Bool =
    let a = Array.init(x -> x + 1, 0);
    Array.toList(a) `assertEq!` Nil

@test
def init02(): Bool =
    let a = Array.init(x -> x + 1, 2);
    Array.toList(a) `assertEq!` 1 :: 2 :: Nil

@test
def init03(): Bool =
    let a = Array.init(x -> x + 1, 50);
    Array.length(a) `assertEq!` 50

/////////////////////////////////////////////////////////////////////////////
// range                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def range01(): Bool = 
    let a = Array.range(1, 0);
    Array.toList(a) `assertEq!` Nil

@test
def range02(): Bool = 
    let a = Array.range(1, 1);
    Array.toList(a) `assertEq!` Nil

@test
def range03(): Bool = 
    let a = Array.range(1, 2);
    Array.toList(a) `assertEq!` 1 :: Nil

@test
def range04(): Bool = 
    let a = Array.range(1, 3);
    Array.toList(a) `assertEq!` 1 :: 2 :: Nil

@test
def range05(): Bool = 
    let a = Array.range(1, 4);
    Array.toList(a) `assertEq!` 1 :: 2 :: 3 :: Nil

@test
def range06(): Bool = 
    let a = Array.range(-1, 3);
    Array.toList(a) `assertEq!` (-1) :: 0 :: 1 :: 2 :: Nil

/////////////////////////////////////////////////////////////////////////////
// append                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def append01(): Bool =
    let a = [1,2,3,4,5];
    let b = [6,7,8];
    let c = Array.append(a,b);
    Array.toList(c) `assertEq!` 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil

@test
def append02(): Bool =
    let a = [1,2,3,4,5];
    let b: Array[Int32] = [];
    let c = Array.append(a,b);
    Array.toList(c) `assertEq!` 1 :: 2 :: 3 :: 4 :: 5 :: Nil

@test
def append03(): Bool =
    let a: Array[Int32] = [];
    let b = [1,2,3,4,5];
    let c = Array.append(a,b);
    Array.toList(c) `assertEq!` 1 :: 2 :: 3 :: 4 :: 5 :: Nil

/////////////////////////////////////////////////////////////////////////////
// flatten                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def flatten01(): Bool =
    let a: Array[Array[Int32]] = [];
    let b = Array.flatten(a);
    Array.toList(b) `assertEq!` Nil

@test
def flatten02(): Bool =
    let a: Array[Array[Int32]] = [[1], [2,3], [4]];
    let b = Array.flatten(a);
    Array.toList(b) `assertEq!` 1 :: 2 :: 3 :: 4 :: Nil

@test
def flatten03(): Bool =
    let a: Array[Array[Int32]] = [[], [1], [2,3], []];
    let b = Array.flatten(a);
    Array.toList(b) `assertEq!` 1 :: 2 :: 3 :: Nil

/////////////////////////////////////////////////////////////////////////////
// toString                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def toString01(): Bool =
    let a: Array[Char] = [];
    Array.toString(a) `assertEq!` ""

@test
def toString02(): Bool =
    let a: Array[Char] = ['H', 'e', 'l', 'l', 'o'];
    Array.toString(a) `assertEq!` "Hello"

@test
def toString03(): Bool =
    let a: Array[Char] = ['→', '1', '→', '2', '→'];
    Array.toString(a) `assertEq!` "→1→2→"

/////////////////////////////////////////////////////////////////////////////
// map                                                                     //
/////////////////////////////////////////////////////////////////////////////
@test
def map01(): Bool =
    let a: Array[Int32] = Array.map(x -> x+1, []);
    Array.toList(a) `assertEq!` Nil

@test
def map02(): Bool =
    let a: Array[Int32] = Array.map(x -> x+1, [0,1,2,3]);
    Array.toList(a) `assertEq!` 1 :: 2 :: 3 :: 4 :: Nil

/////////////////////////////////////////////////////////////////////////////
// map2                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def map201(): Bool =
    let a:Array[Int32] = [];
    let b:Array[Int32] = [];
    let c = Array.map2((x,y) -> x+y, a, b);
    Array.toList(c) `assertEq!` Nil

@test
def map202(): Bool =
    let a = [1,2,3,4,5,6,7,8];
    let b = [1,2,3,4,5];
    let c = Array.map2((x,y) -> x+y, a, b);
    Array.toList(c) `assertEq!` 2 :: 4 :: 6 :: 8 :: 10 :: Nil

/////////////////////////////////////////////////////////////////////////////
// mapWithIndex                                                            //
/////////////////////////////////////////////////////////////////////////////
@test
def mapWithIndex01(): Bool =
    let a:Array[Int32] = Array.mapWithIndex((e, i) -> Int32.max(e,i), []);
    Array.toList(a) `assertEq!` Nil

@test
def mapWithIndex02(): Bool =
    let a = Array.new(3, 6);
    let b:Array[Int32] = Array.mapWithIndex((e, i) -> Int32.max(e,i), a);
    Array.toList(b) `assertEq!` 3 :: 3 :: 3 :: 3 :: 4 :: 5 :: Nil

/////////////////////////////////////////////////////////////////////////////
// scan                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def scan01(): Bool = 
    let a = Array.scan((i, b) -> if (b) i+1 else i+2, 1, []);
    Array.toList(a) `assertEq!` 1 :: Nil

@test
def scan02(): Bool = 
    let a = Array.scan((i, b) -> if (b) i+1 else i+2, 1, [false]);
    Array.toList(a) `assertEq!` 1 :: 3 :: Nil


/////////////////////////////////////////////////////////////////////////////
// scanRight                                                               //
/////////////////////////////////////////////////////////////////////////////
@test
def scanRight01(): Bool = 
    let a = Array.scanRight((b, i) -> if (b) i+1 else i+2, 1, []);
    Array.toList(a) `assertEq!` 1 :: Nil

@test
def scanRight02(): Bool = 
    let a = Array.scanRight((b, i) -> if (b) i+1 else i+2, 1, [false]);
    Array.toList(a) `assertEq!` 3 :: 1 :: Nil



/////////////////////////////////////////////////////////////////////////////
// transpose                                                               //
/////////////////////////////////////////////////////////////////////////////
@test
def transpose01(): Bool = 
    let a = Array.transpose([]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` Nil


@test
def transpose02(): Bool = 
    let a: Array[Array[Int32]] = Array.transpose([[]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` Nil :: Nil

@test
def transpose03(): Bool = 
    let a: Array[Array[Int32]] = Array.transpose([[], []]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` Nil :: Nil :: Nil

@test
def transpose04(): Bool = 
    let a: Array[Array[Int32]] = Array.transpose([[], [], []]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` Nil :: Nil :: Nil :: Nil

@test
def transpose05(): Bool = 
    let a = Array.transpose([ [1] ]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` (1 :: Nil) :: Nil

@test
def transpose06(): Bool = 
    let a = Array.transpose([[1,2]]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` (1 :: Nil) :: (2 :: Nil) :: Nil

@test
def transpose07(): Bool = 
    let a = Array.transpose([[1, 2, 3]]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` (1 :: Nil) :: (2 :: Nil) :: (3 :: Nil) :: Nil

@test
def transpose08(): Bool = 
    let a = Array.transpose([[1, 2, 3, 4]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: Nil) :: (2 :: Nil) :: (3 :: Nil) :: (4 :: Nil) :: Nil

@test
def transpose09(): Bool = 
    let a = Array.transpose([[1], [2]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!`   (1 :: 2 :: Nil) :: Nil

@test
def transpose10(): Bool = 
    let a = Array.transpose([[1], [2], [3]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!`  (1 :: 2 :: 3 :: Nil) :: Nil

@test
def transpose11(): Bool = 
    let a = Array.transpose([[1], [2], [3], [4]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 2 :: 3 :: 4 :: Nil) :: Nil

@test
def transpose12(): Bool = 
    let a = Array.transpose([[1, 2], [3, 4]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 3 :: Nil) :: (2 :: 4 :: Nil) :: Nil

@test
def transpose13(): Bool = 
    let a = Array.transpose([[1, 2, 3], [4, 5, 6]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 4 :: Nil) :: (2 :: 5 :: Nil) :: (3 :: 6 :: Nil) :: Nil

@test
def transpose14(): Bool = 
    let a = Array.transpose([[1, 2, 3, 4], [5, 6, 7, 8]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 5 :: Nil) :: (2 :: 6 :: Nil) :: (3 :: 7 :: Nil) :: (4 :: 8 :: Nil) :: Nil

@test
def transpose15(): Bool = 
    let a = Array.transpose([[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 6 :: Nil) :: (2 :: 7 :: Nil) :: (3 :: 8 :: Nil) :: (4 :: 9 :: Nil) :: (5 :: 10 :: Nil) :: Nil

@test
def transpose16(): Bool = 
    let a = Array.transpose([[1, 2], [3, 4], [5, 6]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 3 :: 5 :: Nil) :: (2 :: 4 :: 6 :: Nil) :: Nil

@test
def transpose17(): Bool = 
    let a = Array.transpose([[1, 2], [3, 4], [5, 6], [7,8]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 3 :: 5 :: 7 :: Nil) :: (2 :: 4 :: 6 :: 8 :: Nil) :: Nil

@test
def transpose18(): Bool = 
    let a = Array.transpose([[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 3 :: 5 :: 7 :: 9 :: Nil) :: (2 :: 4 :: 6 :: 8 :: 10 :: Nil) :: Nil

@test
def transpose19(): Bool = 
    let a = Array.transpose([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
    let b = Array.toList(a) |> List.map(Array.toList);
    b `assertEq!` (1 :: 4 :: 7 :: Nil) :: (2 :: 5 :: 8 :: Nil) :: (3 :: 6 :: 9 :: Nil) :: Nil

@test
def transpose20(): Bool =
    let a = Array.transpose([[1, 2, 3], [4, 5], [7, 8, 9]]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` (1 :: 2 :: 3 :: Nil) :: (4 :: 5 :: Nil) :: (7 :: 8 :: 9 :: Nil) :: Nil

@test
def transpose21(): Bool =
    let a = Array.transpose([[1, 2, 3], [], [7, 8, 9]]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` (1 :: 2 :: 3 :: Nil) :: Nil :: (7 :: 8 :: 9 :: Nil) :: Nil

@test
def transpose22(): Bool = 
    let a = Array.transpose([[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]]);
    let b = Array.toList(a) |> List.map(Array.toList);   
    b `assertEq!` (1 :: 2 :: 3 :: Nil) :: (4 :: 5 :: 6 :: Nil) :: (7 :: 8 :: 9 :: 10 :: Nil) :: Nil