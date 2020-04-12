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

namespace TestStream {

/////////////////////////////////////////////////////////////////////////////
// empty                                                                   //
/////////////////////////////////////////////////////////////////////////////

@test
def empty01(): Bool & Impure =
    let s = Stream.empty();
    Stream.toList(s) == Nil

/////////////////////////////////////////////////////////////////////////////
// range                                                                   //
/////////////////////////////////////////////////////////////////////////////

@test
def range01(): Bool & Impure =
    let s = Stream.range(1, 0);
    Stream.toList(s) == Nil


@test
def range02(): Bool & Impure =
    let s = Stream.range(1, 1);
    Stream.toList(s) == Nil

@test
def range03(): Bool & Impure =
    let s = Stream.range(1, 2);
    Stream.toList(s) == 1 :: Nil

@test
def range04(): Bool & Impure =
    let s = Stream.range(1, 3);
    Stream.toList(s) == 1 :: 2 :: Nil

@test
def range05(): Bool & Impure =
    let s =  Stream.range(1, 4);
     Stream.toList(s) ==  1 :: 2 :: 3 :: Nil

/////////////////////////////////////////////////////////////////////////////
// toList                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def toList01(): Bool & Impure =
    let s = Stream.fromList(Nil);
    Stream.toList(s) == Nil

@test
def toList02(): Bool & Impure =
    let s = Stream.fromList(0 :: 1 :: Nil);
    Stream.toList(s) == 0 :: 1 :: Nil

/////////////////////////////////////////////////////////////////////////////
// foreach                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def foreach01(): Bool & Impure =
    let r = ref 21;
    let s = Stream.fromList(Nil);
    Stream.foreach(x -> r := x, s);
    21 == deref r

@test
def foreach02(): Bool & Impure =
    let r = ref 21;
    let s = Stream.fromList(1 :: 2 :: 3 :: Nil);
    Stream.foreach(x -> r := x, s);
    3 == deref r

/////////////////////////////////////////////////////////////////////////////
// unfold                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def unfold01(): Bool & Impure =
    let s = Stream.unfold(st -> if (true) None else Some(Char.fromInt32(st + 48), st + 1), 0);
    Stream.toList(s) == Nil

@test
def unfold02(): Bool & Impure =
    let s = Stream.unfold(st -> if (st > 0) None else Some(Char.fromInt32(st + 48), st + 1), 0);
    Stream.toList(s) == '0' :: Nil

@test
def unfold03(): Bool & Impure =
    let s = Stream.unfold(st -> if (st > 1) None else Some(Char.fromInt32(st + 48), st + 1), 0);
    Stream.toList(s) == '0' :: '1' :: Nil

@test
def unfold04(): Bool & Impure =
    let s = Stream.unfold(st -> if (st >= 10) None else Some(Char.fromInt32(st + 48), st + 1), 0);
    Stream.toList(s) == '0' :: '1' :: '2' :: '3' :: '4' :: '5' :: '6' :: '7' :: '8' :: '9' :: Nil

@test
def unfold05(): Bool & Impure =
    let s = Stream.unfold(st -> if (st >= 10) None else Some(Char.fromInt32(st + 48), st + 1), 5);
    Stream.toList(s) == '5' :: '6' :: '7' :: '8' :: '9' :: Nil

@test
def unfold06(): Bool & Impure =
    let s = Stream.unfold(st -> if (st >= 10) None else Some(Char.fromInt32(st + 48), st + 2), 0);
    Stream.toList(s) == '0' :: '2' :: '4' :: '6' :: '8' :: Nil

/////////////////////////////////////////////////////////////////////////////
// unfoldWithIterator                                                      //
/////////////////////////////////////////////////////////////////////////////

@test
def unfoldWithIterator01(): Bool & Impure =
    let x = ref 0;
    let step = () ->
        if (true)
            None
        else {
            let c = Char.fromInt32(deref x + 48);
            x := deref x + 1;
            Some(c)
        };
    let s = Stream.unfoldWithIterator(step);
    Stream.toList(s) == Nil

@test
def unfoldWithIterator02(): Bool & Impure =
    let x = ref 0;
    let step = () ->
        if (deref x > 0)
            None
        else {
            let c = Char.fromInt32(deref x + 48);
            x := deref x + 1;
            Some(c)
        };
    let s = Stream.unfoldWithIterator(step);
    Stream.toList(s) == '0' :: Nil

@test
def unfoldWithIterator03(): Bool & Impure =
    let x = ref 0;
    let step = () ->
        if (deref x > 1)
            None
        else {
            let c = Char.fromInt32(deref x + 48);
            x := deref x + 1;
            Some(c)
        };
    let s = Stream.unfoldWithIterator(step);
    Stream.toList(s) == '0' :: '1' :: Nil

@test
def unfoldWithIterator04(): Bool & Impure =
    let x = ref 0;
    let step = () ->
        if (deref x >= 10)
            None
        else {
            let c = Char.fromInt32(deref x + 48);
            x := deref x + 1;
            Some(c)
        };
    let s = Stream.unfoldWithIterator(step);
    Stream.toList(s) == '0' :: '1' :: '2' :: '3' :: '4' :: '5' :: '6' :: '7' :: '8' :: '9' :: Nil

@test
def unfoldWithIterator05(): Bool & Impure =
    let x = ref 5;
    let step = () ->
        if (deref x >= 10)
            None
        else {
            let c = Char.fromInt32(deref x + 48);
            x := deref x + 1;
            Some(c)
        };
    let s = Stream.unfoldWithIterator(step);
    Stream.toList(s) == '5' :: '6' :: '7' :: '8' :: '9' :: Nil

@test
def unfoldWithIterator06(): Bool & Impure =
    let x = ref 0;
    let step = () ->
        if (deref x >= 10)
            None
        else {
            let c = Char.fromInt32(deref x + 48);
            x := deref x + 2;
            Some(c)
        };
    let s = Stream.unfoldWithIterator(step);
    Stream.toList(s) == '0' :: '2' :: '4' :: '6' :: '8' :: Nil

}
