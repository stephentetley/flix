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

namespace TestRegex {

/////////////////////////////////////////////////////////////////////////////
// compile                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def compile01(): Bool & Impure =
    let step = () -> Regex/Pattern.compile("\s+");
    step() |> Result.isOk

/////////////////////////////////////////////////////////////////////////////
// split                                                                   //
/////////////////////////////////////////////////////////////////////////////

@test
def split01(): Bool & Impure =
    use Result.flatMap;
    let step = () -> {
        let* patt = Regex/Pattern.compile("\s+");
        let arr = Regex.split(patt, "aa bb cc");
        Ok(Array.sameElements(arr, ["aa","bb","cc"]))
    };
    Result.getWithDefault(step(), false)

}
