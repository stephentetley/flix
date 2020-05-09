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

use Regex.MatchEvaluator;
use Regex.MatchEvaluator.{MatchEvaluator};
use Regex.Error.{PatternSyntaxException, IllegalStateException};
use Regex/Internal.PrimMatcher;
use Regex.Pattern;
use Regex.Pattern.{Pattern};

namespace Regex {

    ///
    /// Matcher is a monad (reader, error).
    ///
    pub opaque type MatchEvaluator[a] = PrimMatcher ~> Result[a, Regex.Error] 

}

namespace Regex/MatchEvaluator {

    
    pub def return(x: a): MatchEvaluator[a] = 
        MatchEvaluator(_ -> Ok(x) as & Impure)

    pub def map(f: a -> b & e, x: MatchEvaluator[a]): MatchEvaluator[b] =
        MatchEvaluator(r -> 
            let MatchEvaluator(f1) = x;
            match f1(r) { 
                case Ok(a) => {
                    let ans = f(a) as & Impure;
                    Ok(ans)
                }
                case Err(e) => Err(e)
            }
        )        

    def apply1(x: MatchEvaluator[a], m: PrimMatcher): Result[a, Regex.Error] & Impure = 
        let MatchEvaluator(f) = x;
        f(m)

    pub def ap(mf: MatchEvaluator[a -> b], x: MatchEvaluator[a]): MatchEvaluator[b] = 
        MatchEvaluator(r -> 
            let MatchEvaluator(f1) = mf;
            match f1(r) { 
                case Ok(f) => { 
                    let MatchEvaluator(f2) = x;
                    match f2(r) {
                        case Ok(a) => Ok(f(a))
                        case Err(e2) => Err(e2)
                    }
                    
                }
                case Err(e1) => Err(e1)
            }
        )

    pub def bind(x: MatchEvaluator[a], k: a -> MatchEvaluator[b]): MatchEvaluator[b] = 
        MatchEvaluator(r -> 
            let MatchEvaluator(f) = x;
            match f(r) { 
                case Ok(a) => apply1(k(a), r)
                case Err(e) => Err(e)
            }
        )

    pub def flatMap(k: a -> MatchEvaluator[b], x: MatchEvaluator[a]): MatchEvaluator[b] = bind(x, k)



    def liftPrim(fn : PrimMatcher ~> Result[a, Regex.Error]): MatchEvaluator[a] = 
        MatchEvaluator(r -> fn(r))



    pub def value(): MatchEvaluator[String] = liftPrim(Regex/Internal/PrimMatcher.group)

    pub def transformValue(f: String -> String): MatchEvaluator[String] = 
        map(f, value())


    pub def getStart(): MatchEvaluator[Int32] = 
        liftPrim(Regex/Internal/PrimMatcher.start)

    pub def getEnd(): MatchEvaluator[Int32] = liftPrim(Regex/Internal/PrimMatcher.end)
        
    /// TODO Check Java indexing, I'm not sure we want to follow the convention of zero = return everything.        
    pub def getCaptureByIndex(ix: Int32): MatchEvaluator[String] = 
        liftPrim(x -> Regex/Internal/PrimMatcher.groupElementByIndex(x, ix))

    pub def getCaptureByName(label: String): MatchEvaluator[String] = 
        liftPrim(x -> Regex/Internal/PrimMatcher.groupElementByName(x, label))


    ///
    /// Applies the binary function `f` to the values in `o1` and `o2`.
    ///
    /// Returns an error if either `o1` or `o2` are errors.
    ///
    pub def lift2(f: (t1, t2) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2]): MatchEvaluator[u] =
        ap(map(f, o1), o2)

    ///
    /// Applies the ternary function `f` to the values in `o1`, `o2` and `o3`.
    ///
    /// Returns an error if any of `o1`, `o2` and `o3` are errors.
    ///
    pub def lift3(f: (t1, t2, t3) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3]): MatchEvaluator[u] & f =
        ap(lift2(f, o1, o2), o3)

    ///
    /// Applies the 4-ary function `f` to the values in `o1`, `o2`, `o3` and `o4`.
    ///
    /// Returns an error if any of `o1`, `o2`, `o3` and `o4` are errors.
    ///
    pub def lift4(f: (t1, t2, t3, t4) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4]): MatchEvaluator[u] & f =
        ap(lift3(f, o1, o2, o3), o4)

    ///
    /// Applies the 5-ary function `f` to the values in `o1`, `o2`, ... `o5`.
    ///
    /// Returns an error if any of `o1`, `o2`, ... `o5` are errors.
    ///
    pub def lift5(f: (t1, t2, t3, t4, t5) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4], o5: MatchEvaluator[t5]): MatchEvaluator[u] & f =
        ap(lift4(f, o1, o2, o3, o4), o5)

    ///
    /// Applies the 6-ary function `f` to the values in `o1`, `o2`, ... `o6`.
    ///
    /// Returns an error if any of `o1`, `o2`, ... `o6` are errors.
    ///
    pub def lift6(f: (t1, t2, t3, t4, t5, t6) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4], o5: MatchEvaluator[t5], o6: MatchEvaluator[t6]): MatchEvaluator[u] & f =
        ap(lift5(f, o1, o2, o3, o4, o5), o6)

    ///
    /// Applies the 7-ary function `f` to the values in `o1`, `o2`, ... `o7`.
    ///
    /// Returns an error if any of `o1`, `o2`, ... `o7` are errors.
    ///
    pub def lift7(f: (t1, t2, t3, t4, t5, t6, t7) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4], o5: MatchEvaluator[t5], o6: MatchEvaluator[t6], o7: MatchEvaluator[t7]): MatchEvaluator[u] & f=
        ap(lift6(f, o1, o2, o3, o4, o5, o6), o7)

    ///
    /// Applies the 8-ary function `f` to the values in `o1`, `o2`, ... `o8`.
    ///
    /// Returns an error if any of `o1`, `o2`, ... `o8` are errors.
    ///
    pub def lift8(f: (t1, t2, t3, t4, t5, t6, t7, t8) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4], o5: MatchEvaluator[t5], o6: MatchEvaluator[t6], o7: MatchEvaluator[t7], o8: MatchEvaluator[t8]): MatchEvaluator[u] & f =
        ap(lift7(f, o1, o2, o3, o4, o5, o6, o7), o8)

    ///
    /// Applies the 9-ary function `f` to the values in `o1`, `o2`, ... `o9`.
    ///
    /// Returns an error if any of `o1`, `o2`, ... `o9` are errors.
    ///
    pub def lift9(f: (t1, t2, t3, t4, t5, t6, t7, t8, t9) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4], o5: MatchEvaluator[t5], o6: MatchEvaluator[t6], o7: MatchEvaluator[t7], o8: MatchEvaluator[t8], o9: MatchEvaluator[t9]): MatchEvaluator[u] & f =
        ap(lift8(f, o1, o2, o3, o4, o5, o6, o7, o8), o9)

    ///
    /// Applies the 10-ary function `f` to the values in `o1`, `o2`, ... `o10`.
    ///
    /// Returns an error if any of `o1`, `o2`, ... `o10` are errors.
    ///
    pub def lift10(f: (t1, t2, t3, t4, t5, t6, t7, t8, t9, t10) -> u & f, o1: MatchEvaluator[t1], o2: MatchEvaluator[t2], o3: MatchEvaluator[t3], o4: MatchEvaluator[t4], o5: MatchEvaluator[t5], o6: MatchEvaluator[t6], o7: MatchEvaluator[t7], o8: MatchEvaluator[t8], o9: MatchEvaluator[t9], o10: MatchEvaluator[t10]): MatchEvaluator[u] & f =
        ap(lift9(f, o1, o2, o3, o4, o5, o6, o7, o8, o9), o10)

}