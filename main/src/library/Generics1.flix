/*
 *  Copyright 2023 Stephen Tetley
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/// Just a dummy module that uses generic Java types...

mod Generics1 {
/*
    /// Java: static <E> List<E> of(E e1)

    pub def listOf(e: t): ##java.util.List[ToJava.O[t]] \ IO with ToJava[t] =
        import static java.util.List.of(ToJava.O[t]): ##java.util.List[ToJava.O[t]] \ IO with ToJava[t];
        let e1 = ToJava.toJava(e);
        of(e1)


    pub def listOfString(s: String): ##java.util.List[String] \ IO =
        import static java.util.List.of(String): ##java.util.List[String] \ IO;
        of(s)

    pub def newLinkedList(t: t[a]): ##java.util.List[a] \ IO with Foldable[t], ToJava[a] =
        import new java.util.LinkedList(##java.util.Collection[a]): ##java.util.List[a] \ IO as new1 with ToJava[a];
        let l = Adaptor.toLinkedListWith(a -> unchecked_cast(ToJava.toJava(a) as ##java.lang.Object), t);
        let col = unchecked_cast(l as ##java.util.Collection[ToJava.O[t]]);
        new1(col)

*/
}
