/*
 * Copyright 2021 Jakob Schneider Villumsen, Stephen Tetley
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

pub enum Iterator[a: Type, ef: Bool, r: Region] {
    case Iterator(Region[r], Unit -> (Unit -> Iterator.Step[a] \ ef) \ r)
}

mod Iterator {
    use Step.{Ans, Skip, Done}
    use SimpleIterator.{SimpleIterator}

    ///
    /// Represent the "steps" of an iterator.
    ///
    /// This is an expanded version of the `Option` type.
    /// `Ans` is the answer at an intermediate stage of iteration.
    /// `Done` signals that iteration is complete.
    /// `Skip` is essentially an implementation detail. It allows us
    /// to define `filter` and similar functions that "wither" Iterators
    /// without recursively running through the Iterator.
    ///
    pub enum Step[a] {
        case Ans(a)
        case Skip
        case Done
    }

    type alias LoopBody[a: Type, ef: Bool] = Unit -> Step[a] \ ef

    def getRegion(iter: Iterator[a, ef, r]): Region[r] =
        let Iterator(rc, _) = iter;
        rc

    def getLoopBody(iter: Iterator[a, ef, r]): LoopBody[a, ef] \ r =
        let Iterator(_, genLoop) = iter;
        genLoop()

    ///
    /// Returns an iterator built with the stepper function `f`.
    ///
    pub def iterate(rc: Region[r], f: Unit -> Option[a] \ ef): Iterator[a, ef, r] =
        Iterator(rc, _ -> checked_ecast({
            let loop = () -> match f() {
                case Some(a) => Ans(a)
                case None    => Done
            };
            loop
        }))

    pub enum SimpleIterator[a: Type, ef: Bool, r: Region] {
        case SimpleIterator(Region[r], Unit -> (Unit -> Option[a] \ ef) \ r)
    }

    pub def fromSimple(si: SimpleIterator[a, ef, r]): Iterator[a, ef, r] =
        let SimpleIterator(rc, _) = si;
        Iterator(rc, _ -> {
            let SimpleIterator(_, genF) = si;
            let f = genF();
            let loop = () -> match f() {
                case Some(a) => Ans(a)
                case None    => Done
            };
            loop
        })

    ///
    /// Returns an empty iterator.
    ///
    pub def empty(rc: Region[r]): Iterator[a, ef, r] =
        Iterator(rc, _ -> checked_ecast(constant(Done)))

    ///
    /// Returns an iterator containing only a single element, `x`.
    ///
    pub def singleton(rc: Region[r], x: a): Iterator[a, r, r] =
        repeat(rc, 1, x)

    ///
    /// Returns `Some(x)` if `iter` is not empty. Returns `None` otherwise.
    ///
    /// Consumes the head element of `iter`.
    ///
    /// NOT WORKING...
    /// `getLoopBody(iter)` is actually not imperative so `next` has the
    /// same start condition ever call...
    pub def next(iter: Iterator[a, ef, r]): Option[a] \ { ef, Read(r) } =
        let iterF = getLoopBody(iter);
        def loop() = match iterF() {
            case Ans(a) => Some(a)
            case Skip   => loop()
            case Done   => None
        };
        loop()

    ///
    /// Returns an iterator of all integers between `b` (inclusive) and `e` (exclusive).
    ///
    /// Returns an empty iterator if `b >= e`.
    ///
    pub def range(rc: Region[r], b: Int32, e: Int32): Iterator[Int32, r, r] =
        Iterator(rc, _ -> {
            let pos = ref b @ rc;
            let loop = () ->
                if (e <= b)
                    Done
            else {
                match (deref pos) {
                    case i if i < e => pos := i+1; Ans(i)
                    case _          => Done
                }
            };
            loop
        })


    ///
    /// Returns an iterator over an iterable with the element `x` repeated `n` times.
    ///
    /// Returns an empty iterator if `n < 0`.
    ///
    pub def repeat(rc: Region[r], n: Int32, x: a): Iterator[a, r, r] =
        Iterator(rc, _ -> {
            let ix = ref n @ rc;
            let loop = () -> {
                let i = deref ix;
                if (i < 1)
                    Done
                else {
                    ix := i-1;
                    Ans(x)
                }
            };
            loop
        })

    ///
    /// Returns the sum of all elements in the iterator `iter`.
    ///
    /// Consumes the entire iterator.
    ///
    pub def sum(iter: Iterator[Int32, ef, r]): Int32 \ { ef, Read(r) } =
        foldLeft((acc, x) -> acc + x, 0, iter)

    ///
    /// Returns the sum of all elements in the iterator `iter` according to the function `f`.
    ///
    /// Consumes the entire iterator.
    ///
    pub def sumWith(f: a -> Int32 \ ef2, iter: Iterator[a, ef1, r]): Int32 \ { ef1, ef2, Read(r) } =
        foldLeft((acc, x) -> acc + f(x), 0, iter)

    ///
    /// Returns the contents of `iter` as an array.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toArray(rc: Region[r1], iter: Iterator[a, ef, r2]): Array[a, r1] \ { ef, r1, r2 } = region rc1 {
        let m = MutList.new(rc1);
        forEach(a -> MutList.push!(a, m), iter);
        MutList.toArray(rc, m)
    }

    ///
    /// Returns the contents of `iter` as an array.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toVector(iter: Iterator[a, ef, r]): Vector[a] \ { ef, r } = region rc {
        let m = MutList.new(rc);
        forEach(a -> MutList.push!(a, m), iter);
        MutList.toVector(m)
    }

    ///
    /// Returns the contents of `iter` as a list.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toList(iter: Iterator[a, ef, r]): List[a] \ { ef, Read(r) } =
        foldRight((a, acc) -> a :: acc, Nil, iter)


    ///
    /// Returns the contents of `iter` as a chain.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toChain(iter: Iterator[a, ef, r]): Chain[a] \ { ef, Read(r) } =
        foldLeft((acc, a) -> Chain.snoc(acc, a), Chain.empty(), iter)

    ///
    /// Returns the contents of `iter` as a map.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toMap(iter: Iterator[(k, v), ef, r]): Map[k, v] \ { ef, Read(r) } with Order[k] =
        foldLeft((acc, a) -> (match (k, v) -> Map.insert(k, v, acc))(a), Map.empty(), iter)

    ///
    /// Returns the contents of `iter` as a `Some(Nel)` if `iter` is not empty. Returns None otherwise.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toNel(iter: Iterator[a, ef, r]): Option[Nel[a]] \ { ef, Read(r) } =
        toList(iter) |> List.toNel

    ///
    /// Returns the contents of `iter` as a Nec.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toNec(iter: Iterator[a, ef, r]): Option[Nec[a]] \ { ef, Read(r) } = match next(iter) {
        case Some(a) => foldLeft((acc, x) -> Nec.snoc(acc, x), Nec.singleton(a), iter) |> Some
        case None    => None
    }

    ///
    /// Returns the contents of `iter` as a MutDeque.
    ///
    /// Consumes the entire iterator.
    ///
    pub def toMutDeque(rc: Region[r1], iter: Iterator[a, ef, r2]): MutDeque[a, r1] \ { ef, Read(r2), Write(r1) } =
        let d = MutDeque.new(rc);
        forEach(x -> MutDeque.pushBack(x, d), iter);
        d

    ///
    /// Returns the contents of `iter` as a set. Consumes the entire iterator.
    ///
    pub def toSet(iter: Iterator[a, ef, r]): Set[a] \ { ef, Read(r) } with Order[a] =
        foldLeft((acc, a) -> Set.insert(a, acc), Set.empty(), iter)

    ///
    /// Applies `f` to every element of `iter`.
    ///
    /// Consumes the entire iterator.
    ///
    pub def forEach(f: a -> Unit \ ef2, iter: Iterator[a, ef1, r]): Unit \ { ef1, ef2, Read(r) } =
        let iterF = getLoopBody(iter);
        def loop() = match iterF() {
            case Skip   => loop()
            case Ans(a) => f(a); loop()
            case Done   => ()
        };
        loop()

    ///
    /// Applies `f` to every element of `iter` along with that element's index.
    ///
    /// Consumes the entire iterator.
    ///
    pub def forEachWithIndex(f: (Int32, a) -> Unit \ ef2, iter: Iterator[a, ef1, r]): Unit \ { ef1, ef2, Read(r) } =
        let iterF = getLoopBody(iter);
        def loop(i) = match iterF() {
            case Skip   => loop(i)
            case Ans(a) => f(i, a); loop(i+1)
            case Done   => ()
        };
        loop(0)

    ///
    /// Returns an iterator with every element of the iterator `iter` that
    /// satisfies the predicate `f`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def filter(f: a -> Bool \ ef2, iter: Iterator[a, ef1, r]): Iterator[a, ef1 and ef2, r] =
        Iterator(getRegion(iter), _ -> {
            let iterF = getLoopBody(iter);
            let loop = () -> match iterF() {
                case Ans(a) => if (f(a)) Ans(a) else Skip
                case Skip   => Skip
                case Done   => Done
            };
            loop
        })

    ///
    /// Returns an iterator with every `f` lazily applied to each element in `iter`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    pub def map(f: a -> b \ ef2, iter: Iterator[a, ef1, r]): Iterator[b, ef1 and ef2, r] =
        Iterator(getRegion(iter), _ -> {
            let iterF = getLoopBody(iter);
            let loop = () -> match iterF() {
                case Ans(a) => Ans(f(a))
                case Skip   => Skip
                case Done   => Done
            };
            loop
        })

    ///
    /// Returns an iterator with every `f` lazily applied to each element in `iter`
    /// together with its index.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    pub def mapWithIndex(f: (Int32, a) -> b \ ef2, iter: Iterator[a, ef1, r]): Iterator[b, ef1 and ef2 and r, r] =
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let iterF = getLoopBody(iter);
            let ix = ref 0 @ rc;
            let loop = () -> match iterF() {
                case Ans(a) => { let i = deref ix; ix := i + 1; Ans(f(i, a)) }
                case Skip   => Skip
                case Done   => Done
            };
            loop
        })

    ///
    /// Returns an iterator with every occurrence of `from` replaced by `to` in `iter`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    pub def replace(from: {from = a}, to: {to = a}, iter: Iterator[a, ef, r]): Iterator[a, ef, r] with Eq[a] =
        map(a -> if (a == from.from) to.to else a, iter)

    ///
    /// Returns `iterB` appended to (the end of) `iterA`.
    ///
    /// Does *not* consume any elements from either iterator.
    ///
    /// The original iterators `iterA` and `iterB` should *not* be reused.
    ///
    pub def append(iter1: Iterator[a, ef1, r], iter2: Iterator[a, ef2, r]): Iterator[a, ef1 and ef2 and r, r] =
        Iterator(getRegion(iter1), _ -> {
            let iter1F = getLoopBody(iter1);
            let iter2F = getLoopBody(iter2);
            def loop2(x) = match x {
                case Ans(a) => Ans(a)
                case Skip   => loop2(iter2F())
                case Done   => Done
            };
            def loop1(x) = match x {
                case Ans(a) => Ans(a)
                case Skip   => loop1(iter1F())
                case Done   => loop2(iter2F())
            };
            _ -> loop1(iter1F())
        })


    ///
    /// Returns an iterator where the element at index `i` is `(a, b)` where
    /// `a` is the element at index `i` in `iterA` and `b` is the element at index `i` in `iterB`.
    ///
    /// Does *not* consume any elements from either iterator.
    ///
    /// If either `iterA` or `iterB` is depleted, then no further elements are added to the resulting iterator.
    ///
    /// The original iterators `iterA` and `iterB` should *not* be reused.
    ///
    /// An iterator should *never* be zipped with itself.
    ///
    pub def zip(iterA: Iterator[a, ef1, r], iterB: Iterator[b, ef2, r]): Iterator[(a, b), ef1 and ef2, r] =
        zipWith((a, b) -> (a, b), iterA, iterB)

    ///
    /// Returns an iterator where the element at index `i` is `f(a, b)` where
    /// `a` is the element at index `i` in `iterA` and `b` is the element at index `i` in `iterB`.
    ///
    /// Does *not* consume any elements from either iterator.
    ///
    /// If either `iterA` or `iterB` becomes depleted, then no further elements are added to the resulting list.
    ///
    /// The original iterators `iterA` and `iterB` should *not* be reused.
    ///
    /// An iterator should *never* be zipped with itself.
    ///
    pub def zipWith(f: (a, b) -> c \ ef3, iterA: Iterator[a, ef1, r], iterB: Iterator[b, ef2, r]): Iterator[c, ef1 and ef2 and ef3, r] =
        Iterator(getRegion(iterA), _ -> {
            let iter1F = getLoopBody(iterA);
            let iter2F = getLoopBody(iterB);
            let loop = () -> match (iter1F(), iter2F()) {
                case (Ans(a), Ans(b)) => Ans(f(a, b))
                case (Ans(a), Skip)   => zipWithGoRight(b -> f(a, b), iter2F)
                case (Skip, Ans(b))   => zipWithGoLeft(iter1F, a -> f(a, b))
                case (Skip, Skip)     => Skip
                case (_, _)           => Done
            };
            loop
        })

    ///
    /// Helper function for `zipWith`.
    ///
    def zipWithGoLeft(iter: Unit -> Step[a] \ ef1, f: a -> c \ ef2): Step[c] \ { ef1, ef2 } = match iter() {
        case Ans(a) => Ans(f(a))
        case Skip   => zipWithGoLeft(iter, f)
        case Done   => Done
    }

    ///
    /// Helper function for `zipWith`.
    ///
    def zipWithGoRight(f: b -> c \ ef2, iter: Unit -> Step[b] \ ef1): Step[c] \ { ef1, ef2 } = match iter() {
        case Ans(b) => Ans(f(b))
        case Skip   => zipWithGoRight(f, iter)
        case Done   => Done
    }

    ///
    /// Returns an iterator where the element at index `i` is `(a, i)` where
    /// `a` is the element at index `i` in `iter`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def zipWithIndex(iter: Iterator[a, ef, r]): Iterator[(Int32, a), ef and r, r] =
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let ix = ref 0 @ rc;
            getLoopBody(map(x -> {let i = deref ix; ix:= i + 1; (i, x)}, iter))
        })

    ///
    /// Alias for `zipWithIndex`.
    ///
    pub def enumerator(iter: Iterator[a, ef, r]): Iterator[(Int32, a), ef and r, r] =
        zipWithIndex(iter)

    ///
    /// Applies `f` to a start value `s` and all elements in `iter` going from left to right.
    ///
    /// That is, the result is of the form: `f(...f(f(s, x1), x2)..., xn)`.
    ///
    /// Consumes the entire iterator.
    ///
    pub def foldLeft(f: (b, a) -> b \ ef2, s: b, iter: Iterator[a, ef1, r]): b \ { ef1, ef2, r } =
        let iterF = getLoopBody(iter);
        def loop(acc) = match iterF() {
            case Skip   => loop(acc)
            case Ans(a) => loop(f(acc, a))
            case Done   => acc
        };
        loop(s)

    ///
    /// Applies `f` to a start value `s` and all elements in `iter` going from right to left.
    ///
    /// That is, the result is of the form: `f(x1, ...f(xn-1, f(xn, s))...)`.
    ///
    /// Consumes the entire iterator.
    ///
    pub def foldRight(f: (a, b) -> b \ ef2, s: b, iter: Iterator[a, ef1, r]): b \ { ef1, ef2, r } =
        let iterF = getLoopBody(iter);
        def loop(k) = match iterF() {
            case Skip   => loop(k)
            case Ans(a) => loop(ks -> k(f(a, ks)))
            case Done   => k(s)

        };
        loop(identity)

    ///
    /// Applies `f` to a start value `z` and all elements in `iter` going from right to left.
    ///
    /// That is, the result is of the form: `f(x1, ...f(xn-1, f(xn, z))...)`.
    /// A `foldRightWithCont` allows early termination by not calling the continuation.
    ///
    /// Consumes the entire iterator.
    ///
    pub def foldRightWithCont(f: (a, Unit -> b \ { ef, Read(r) }) -> b \ ef, z: b, iter: Iterator[a, ef, r]): b \ { ef, r } =
        let iterF = getLoopBody(iter);
        def loop() = match iterF() {
            case Skip   => loop()
            case Ans(a) => f(a, _ -> loop())
            case Done   => z
        };
        loop()

    ///
    /// Returns the result of mapping each element and combining the results.
    ///
    pub def foldMap(f: a -> b \ ef2, iter: Iterator[a, ef1, r]): b \ { ef1, ef2, r } with Monoid[b] =
        foldLeft((acc, x) -> Monoid.combine(acc, f(x)), Monoid.empty(), iter)

    ///
    /// Applies `f` to all elements in `iter` going from left to right until a single value `v` is obtained.  Returns `Some(v)`.
    ///
    /// That is, the result is of the form: `Some(f(...f(f(x1, x2), x3)..., xn))`
    ///
    /// Returns `None` if `iter` is empty.
    ///
    /// Consumes the entire iterator.
    ///
    pub def reduceLeft(f: (a, a) -> a \ ef2, iter: Iterator[a, ef1, r]): Option[a] \ { ef1, ef2, r } =
        match next(iter) {
            case Some(x) => foldLeft(f, x, iter) |> Some
            case None    => None
        }

    ///
    /// Returns an iterator over the results of `f`.
    ///
    /// If `f` returns `Ok(x)`, then the next element is `x`.
    ///
    /// If `f` returns `Err(e)`, then the iterator is depleted.
    ///
    pub def unfoldWithOk(rc: Region[r], f: Unit -> Result[e, a] \ ef): Iterator[a, ef, r] =
        let iterF = () -> Result.toOption(f());
        iterate(rc, iterF)

    ///
    /// Returns `iter` without the first `n` elements.
    ///
    /// Returns an empty iterator if `n` is larger than the number of elements in `iter`.
    /// Returns `iter` if `n < 0`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def drop(n: Int32, iter: Iterator[a, ef, r]): Iterator[a, ef and r, r] =
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let iterF = getLoopBody(iter);
            let ix = ref n @ rc;
            def loop() = {
                let i = deref ix;
                ix := i - 1;
                match iterF() {
                    case Ans(a)  => if (i > 0) loop() else Ans(a)
                    case Skip    => loop()
                    case Done    => Done
                }
            };
            loop
        })

    ///
    /// Returns `iter` with the first `n` elements.
    ///
    /// Returns `iter` if `n` is larger than the number of elements in `iter`.
    /// Returns an empty iterator if `n < 0`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def take(n: Int32, iter: Iterator[a, ef, r]): Iterator[a, ef and r, r] =
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let iterF = getLoopBody(iter);
            let ix = ref n @ rc;
            def loop() = {
                let i = deref ix;
                if (i < 1)
                    Done
                else
                    match iterF() {
                        case Ans(a) => {ix := i-1; Ans(a)}
                        case Skip   => Skip
                        case Done   => Done
                    }
            };
            loop
        })

    ///
    /// Returns the longest prefix of `iter` that satisfies the predicate `f`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def takeWhile(f: a -> Bool \ ef2, iter: Iterator[a, ef1, r]): Iterator[a, ef1 and ef2 and r, r] =
        Iterator(getRegion(iter), _ -> {
            let iterF = getLoopBody(iter);
            def loop() = match iterF() {
                case Ans(a) => if (f(a)) Ans(a) else Done
                case Skip   => loop()
                case Done   => Done
            };
            loop
        })


    ///
    /// Returns `iter` without the longest prefix that satisfies the predicate `f`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def dropWhile(f: a -> Bool \ ef2, iter: Iterator[a, ef1, r]): Iterator[a, ef1 and ef2 and r, r]=
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let iterF = getLoopBody(iter);
            let start = ref true @ rc;
            def loop() = match iterF() {
                case Ans(a) =>
                    if (deref start) {
                        if (f(a)) Skip else { start:= false; Ans(a) }
                    } else {
                        Ans(a)
                    }
                case Skip    => Skip
                case Done    => Done
            };
            loop
        })

    ///
    /// Returns the result of applying `f` to every element in `iter` and concatenating the results.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// Currently `f` has to generate an iterator with region `r`.
    ///
    pub def flatMap(f: a -> Iterator[b, ef2, r] \ ef3, ma: Iterator[a, ef1, r]): Iterator[b, ef1 and ef2 and ef3 and r, r] =
        let rc = getRegion(ma);
        Iterator(rc, _ -> {
            let iterF = getLoopBody(ma);
            let innerIter = ref empty(rc) @ rc;
            let inside = ref false @ rc;
            def innerLoop() = {
                let innerF = getLoopBody(deref innerIter);
                match innerF() {
                    case Ans(b) => Ans(b)
                    case Skip   => innerLoop()
                    case Done   => Done
                }
            };
            def outerLoop() = {
                if (deref inside) {
                    match innerLoop() {
                        case Done => {inside := false; outerLoop()}
                        case ans  => ans
                    }
                } else {
                    match iterF() {
                        case Ans(a) => {
                            inside := true;
                            innerIter := f(a);
                            outerLoop()
                        }
                        case Skip   => outerLoop()
                        case Done   => Done
                    }
                }
            };
            outerLoop
        })

    ///
    /// Returns an iterator with `a` inserted between every of `iter`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    pub def intersperse(sep: a, iter: Iterator[a, ef, r]): Iterator[a, ef and r, r] \ Write(r) =
        let Iterator(rc, _) = iter;
        let start = ref true @ rc;
        let step = x ->
            if (deref start) {
                start := false;
                singleton(rc, x)
            } else {
                cons(sep, singleton(rc, x))
            };
        flatMap(step, iter)

    ///
    /// Returns the concatenation of the elements in `iter` with the elements of `sep` inserted between every two adjacent elements.
    ///
    /// That is, returns `b1 :: a1 ... an :: b2 :: ... bn-1 :: a1 :: ... :: an :: bn :: Nil`.
    ///
    /// Does *not* consume any elements from either iterator.
    ///
    /// The original iterators `sep` and `iter` should not be reused.
    ///
    pub def intercalate(sep: t[a], iter: Iterator[Iterator[a, ef1 and r, r], ef, r]): Iterator[a, ef and ef1 and r, r]  with Foldable[t] =
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let start = ref true @ rc;
            let sepL = Foldable.toList(sep);
            let step = innerIter -> {
                if (deref start) {
                    start := false;
                    innerIter
                } else {
                    append(ofList(rc, sepL), innerIter)
                }
            };
            getLoopBody(flatMap(step, iter))
       })


    ///
    /// Helper for `intercalate`.
    ///
    def ofList(rc: Region[r], xs: List[a]): Iterator[a, r, r] =
        Iterator(rc, _ -> {
            let ls = ref xs @ rc;
            let loop = () -> {
                match (deref ls) {
                    case Nil     => Done
                    case x :: rs => ls := rs; Ans(x)
                }
            };
            loop
        })


    ///
    /// Returns the concatenation of the string representation
    /// of each element in `iter` with `sep` inserted between each element.
    ///
    /// Consumes the entire iterator.
    ///
    pub def join(sep: String, iter: Iterator[a, ef, r]): String \ { ef, r } with ToString[a] =
        joinWith(ToString.toString, sep, iter)

    ///
    /// Returns the concatenation of the string representation
    /// of each element in `iter` according to `f` with `sep` inserted between each element.
    ///
    /// Consumes the entire iterator.
    ///
    pub def joinWith(f: a -> String \ ef2, sep: String, iter: Iterator[a, ef1, r]): String \ { ef1, ef2, r } = region rc {
        let sb = StringBuilder.new(rc);
        match next(iter) {
            case Some(a) => {
                StringBuilder.append!(f(a), sb);
                forEach(x -> {StringBuilder.append!(sep, sb); StringBuilder.append!(f(x), sb)}, iter)
            }
            case None    => ()
        };
        StringBuilder.toString(sb)
    }

    ///
    /// Returns an iterator with every element of the iterator `iter` that
    /// produces `Some(_)` the from the function `f`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def filterMap(f: a -> Option[b] \ ef2, iter: Iterator[a, ef1, r]): Iterator[b, ef1 and ef2, r] =
        Iterator(getRegion(iter), _ -> {
            let iterF = getLoopBody(iter);
            let loop = () -> match iterF() {
                case Ans(a) => match (f(a)) {
                    case Some(a1) => Ans(a1)
                    case None     => Skip
                }
                case Skip   => Skip
                case Done   => Done
            };
            loop
        })

    ///
    /// Returns an iterator with the element `x` appended to the
    /// front of iterator `iter`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def cons(x: a, iter: Iterator[a, ef, r]): Iterator[a, ef and r, r] =
        let rc = getRegion(iter);
        Iterator(rc, _ -> {
            let iterF = getLoopBody(iter);
            let first = ref true @ rc;
            let loop = () ->  {
                if (deref first) {
                    first := false;
                    Ans(x)
                }
                else
                    iterF()
            };
            loop
        })

    ///
    /// Returns the concatenation of the nested iterators in `iter`.
    ///
    /// Does *not* consume any elements from the iterator.
    ///
    /// The original iterator `iter` should *not* be reused.
    ///
    pub def flatten(iter: Iterator[Iterator[a, ef1, r], ef2, r]): Iterator[a, ef1 and ef2 and r, r] =
        flatMap(identity, iter)

}
