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

    pub def map(f: a -> b, x: MatchEvaluator[a]): MatchEvaluator[b] = 
        MatchEvaluator(r -> 
            let MatchEvaluator(f1) = x;
            match f1(r) { 
                case Ok(a) => Ok(f(a))
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


    pub def getStart(): MatchEvaluator[Int32] = 
        liftPrim(Regex/Internal/PrimMatcher.start)

    pub def getEnd(): MatchEvaluator[Int32] = liftPrim(Regex/Internal/PrimMatcher.end)
        
    /// TODO Check Java indexing, I'm not sure we want to follow the convention of zero = return everything.        
    pub def getCaptureByIndex(ix: Int32): MatchEvaluator[String] = 
        liftPrim(x -> Regex/Internal/PrimMatcher.groupElementByIndex(x, ix))

    pub def getCaptureByName(label: String): MatchEvaluator[String] = 
        liftPrim(x -> Regex/Internal/PrimMatcher.groupElementByName(x, label))



}