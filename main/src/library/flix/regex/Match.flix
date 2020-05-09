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

use Regex.{Match};
use Regex.Match.{Match};

use Regex.Pattern;
use Regex.Pattern.Pattern;

/// This is a simple "steppable" matcher like .Net `Regex.Match`.

namespace Regex {
    
    pub opaque type Match = { primMatcher: Regex/Internal.PrimMatcher, success: Ref[Bool] }

}

namespace Regex/Match {

    pub def findMatch(pattern: Pattern, input: String): Match & Impure = 
        use Regex/Internal/PrimMatcher.{newPrimMatcher, find};
        let Pattern(p1) = pattern;
        let m1 = newPrimMatcher(p1, input);
        let sc = m1.find();
        Match({ primMatcher = m1, success = ref sc})

    pub def next(x: Match): Unit & Impure = 
        use Regex/Internal/PrimMatcher.{newPrimMatcher, find};
        let Match(m1) = x;
        let matcher = m1.primMatcher;
        let scref = m1.success;
        let sc = matcher.find();
        scref := sc;
        ()

    pub def success(x: Match): Bool & Impure = 
        let Match(m1) = x;
        let scref = m1.success;
        deref scref
    
    pub def value(x: Match): Option[String] & Impure = 
        use Regex/Internal/PrimMatcher.{group};
        let Match(m1) = x;
        let matcher = m1.primMatcher;
        let scref = m1.success;
        if (deref scref == true) {
            let ans = matcher.group();
            match ans { 
                case Ok(s) => Some(s)
                case Err(_) => None
            }
        } else None

    /// TODO Check Java indexing, I'm not sure we want to follow the convention of zero = return everything.
    pub def getGroupByIndex(x: Match, ix: Int32): Result[String, Regex.Error] & Impure = 
        use Regex/Internal/PrimMatcher.{groupElementByIndex};
        let Match(m1) = x;
        let matcher = m1.primMatcher;
        let scref = m1.success;
        if (deref scref == true)
            matcher.groupElementByIndex(ix)
        else 
            Err(Regex/Error.IllegalStateException)

    pub def getGroupByLabel(x: Match, label: String): Result[String, Regex.Error] & Impure = 
        use Regex/Internal/PrimMatcher.{groupElementByName};
        let Match(m1) = x;
        let matcher = m1.primMatcher;
        let scref = m1.success;
        if (deref scref == true)
            matcher.groupElementByName(label)
        else 
            Err(Regex/Error.IllegalStateException)

    

}        



