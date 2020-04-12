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


pub opaque type Stream[a, e] = Unit -> (Unit -> Step[a] & e) & Impure

enum Step[a] {
    case Done,
    case Skip,
    case Yield(a)
}

namespace Stream { 

    ///
    /// Returns the empty stream.
    ///
    pub def empty(): Stream[a, Impure] =
        Stream(() ->
            let x = ref true;
            let next = () -> if (deref x) Done else Done;
            next
        )

    ///
    /// Returns a Stream of all integers between `b` (inclusive) and `e` (exclusive).
    ///
    /// Returns an empty Stream if `b >= e`.
    ///
    pub def range(b: Int32, e: Int32): Stream[Int32, Impure] =
        if (b >= e)
            empty()
        else
            rangeHelper(b, e)

    ///
    /// Helper function for `range`
    ///
    /// Precodition: b < e
    ///
    def rangeHelper(b: Int32, e: Int32): Stream[Int32, Impure] =
        Stream(() -> 
            let x = ref b;
            let next = () -> 
                if (deref x > e)
                    Done
                else {
                    let p = deref x;
                    x := deref x + 1;
                    Yield(p)
                };
            next 
            )

    pub def toList(s: Stream[a, f]): List[a] & f = 
        let Stream(body) = s;
        toListHelper(body(), Nil) 

    def toListHelper(sf : Unit -> Step[a] & f, ac: List[a]) : List[a] & f = 
        match sf() {
            case Done     => List.reverse(ac)
            case Skip     => toListHelper(sf, ac)
            case Yield(a) => toListHelper(sf, a :: ac)
        }

    pub def foreach(f: a -> Unit & Impure, s: Stream[a, f]): Unit & Impure = 
        let Stream(body) = s;
        foreachHelper(f, body()) 

    def foreachHelper(f: a -> Unit & Impure, sf : Unit -> Step[a] & f): Unit & Impure = 
        match sf() {
            case Done => ()
            case Skip => foreachHelper(f, sf)
            case Yield(a) => {
                f(a) as & Impure;
                foreachHelper(f, sf)
            }
        }


    pub def unfold(f: b -> Option[(a,b)], st: b): Stream[a, Impure] =
        Stream(() -> 
            let state = ref st;
            let next = () -> 
                match f(deref state) {
                    case None => Done
                    case Some(x,st2) => {
                        state := st2;
                        Yield(x)
                    }
                };        
            next
        )

    pub def unfoldWithIterator(f: () -> Option[a] & f): Stream[a, f] =
        Stream(() ->
            let next = () ->
                match f() {
                    case None => Done
                    case Some(x) => Yield(x)
                };
            next as & f
        )

    ///
    /// Returns the result of applying `f` to every element in Stream `s`.
    ///
    pub def map(f: a -> b, s: Stream[a, f]): Stream[b, f] =
        Stream(() -> 
            let Stream(body) = s;
            let sf = body();
            let next = () -> 
                match sf() {
                    case Yield(a) => Yield(f(a))
                    case x        => x                    
                };
            next 
        )


    pub def ofList(xs: List[a]): Stream[a, Impure] = 
        Stream(() -> 
            let rxs = ref xs;
            let next = () -> 
                match (deref rxs) {
                    case Nil => Done
                    case x :: rs => {
                        rxs := rs;
                        Yield(x)
                    }
                };
            next 
        )

    pub def ofArray(arr: Array[a]): Stream[a, Impure] = 
        Stream(() -> 
            let x = ref 0;
            let next = () -> {
                let ix = deref x;
                if (ix >= Array.length(arr))
                    Done
                else {
                    let p = Array.get(arr, ix);
                    x := ix + 1;
                    Yield(p)
                }
            };
            next 
        )



    
    pub def cons(x: a, s: Stream[a, e]) : Stream[a, Impure] = 
        Stream(() -> 
            let Stream(body) = s;
            let sf = body();
            let initial = ref true;
            let next = () -> 
                if (deref initial != true) 
                    sf()
                else {
                    initial := false;
                    Yield(x)
                };            
            next
        )

    pub def zip(s1: Stream[a, f], s2: Stream[b, f]): Stream[(a,b), f] = zipWith((a,b) -> (a,b), s1, s2)
        
    pub def zipWith(f: (a,b) -> c, s1: Stream[a, f], s2: Stream[b, f]): Stream[c, f] = 
        Stream(() -> 
            let Stream(body1) = s1;
            let Stream(body2) = s2;
            let sf1 = body1();
            let sf2 = body2();
            let next = () -> zipWithHelper(f, sf1, sf2);
            next 
        )


    def zipWithHelper(f: (a,b) -> c, sf1: Unit -> Step[a] & f, sf2: Unit -> Step[b] & f) : Step[c] & f= 
        match (sf1(), sf2()) {
            case (Yield(a), Yield(b)) => Yield(f(a,b))
            case (Yield(a), Skip)     => zipWithHelperLeft(f, a, sf2)
            case (Skip, Yield(b))     => zipWithHelperRight(f, sf1, b)
            case (_,_)                => Done
        }

    def zipWithHelperLeft(f: (a,b) -> c, x: a, sf: Unit -> Step[b] & f) : Step[(a,b)] & f = 
        match sf() {
            case Yield(y)   => Yield(f(x,y))
            case Done       => Done
            case Skip       => zipWithHelperLeft(f, x, sf)
        }

    def zipWithHelperRight(f: (a,b) -> c,sf: Unit -> Step[a] & f, y: b) : Step[(a,b)] & f = 
        match sf() {
            case Yield(x)   => Yield(f(x,y))
            case Done       => Done
            case Skip       => zipWithHelperRight(f, sf, y)
        }

    pub def fold(f: (b, a) -> b, ac: b, s: Stream[a, f]): b & f = 
        let Stream(body) = s;
        foldHelper(f, ac, body()) 

    def foldHelper(f: (b,a) -> b, ac: b, sf : Unit -> Step[a] & f): b & f = 
        match sf() {
            case Done => ac
            case Skip => foldHelper(f, ac, sf)
            case Yield(a) => foldHelper(f, f(ac,a), sf)
        }

    pub def append(s1: Stream[a, f], s2: Stream[a, f]): Stream[a, f] = 
        Stream(() -> 
            let Stream(body1) = s1;
            let Stream(body2) = s2;
            let sf1 = body1();
            let sf2 = body2();
            let from1 = ref true;
            let next = () ->
                if (deref from1 == false)
                    sf2()
                else  
                    match sf1() {
                        case Skip => Skip
                        case Yield(a) => Yield(a)
                        case Done => {
                            from1 := false;
                            Skip
                        }
                    };
            next 
        )

    pub def take(n: Int32, s: Stream[a, f]): Stream[b, f] = 
        Stream(() -> 
            let x = ref 0;
            let Stream(body) = s;
            let sf = body();
            let next = () -> 
                if (deref x >= n)
                    Done
                else {
                    match sf() {
                        case Yield(a) => {
                            x := deref x + 1;
                            Yield(a)
                        }
                        case ans => ans
                    }
                };
            next 
        )

    pub def drop(n: Int32, s: Stream[a, f]): Stream[b, f] = 
        Stream(() -> 
            let x = ref n;
            let Stream(body) = s;
            let sf = body();
            let next = () -> match sf() {
                case Yield(a) =>
                    if (deref x < 0)
                        Yield(a)
                    else {                
                        x := deref x - 1;
                        Skip
                    }
                case ans => ans
                };
            next 
        )

    pub def filter(f: a -> Bool, s: Stream[a, f]): Stream[a, f] = 
        Stream(() -> 
            let Stream(body) = s;
            let sf = body();
            let next = () -> 
                match sf() { 
                    case Done => Done
                    case Skip => Skip
                    case Yield(a) => 
                        if (f(a) == false) 
                            Skip
                        else
                            Yield(a)    
                };
            next 
        )    

}