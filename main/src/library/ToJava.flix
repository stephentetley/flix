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

///
/// A type class for marshaling values to Java.
///
pub class ToJava[t: Type] {
    type O
    pub def toJava(t: t): ToJava.O[t] \ IO
}

instance ToJava[Bool] {
    type O = ##java.lang.Boolean
    pub def toJava(x: Bool): ##java.lang.Boolean \ IO =
        checked_ecast(ToJava.boolToJava(x))
}

instance ToJava[Char] {
    type O = ##java.lang.Character
    pub def toJava(x: Char): ##java.lang.Character \ IO =
        checked_ecast(ToJava.charToJava(x))
}

instance ToJava[Int8] {
    type O = ##java.lang.Byte
    pub def toJava(x: Int8): ##java.lang.Byte \ IO =
        checked_ecast(ToJava.int8ToJava(x))
}

instance ToJava[Int16] {
    type O = ##java.lang.Short
    pub def toJava(x: Int16): ##java.lang.Short \ IO =
        checked_ecast(ToJava.int16ToJava(x))
}

instance ToJava[Int32] {
    type O = ##java.lang.Integer
    pub def toJava(x: Int32): ##java.lang.Integer \ IO =
        checked_ecast(ToJava.int32ToJava(x))
}

instance ToJava[Int64] {
    type O = ##java.lang.Long
    pub def toJava(x: Int64): ##java.lang.Long \ IO =
        checked_ecast(ToJava.int64ToJava(x))
}

instance ToJava[Float32] {
    type O = ##java.lang.Float
    pub def toJava(x: Float32): ##java.lang.Float \ IO =
        checked_ecast(ToJava.float32ToJava(x))
}

instance ToJava[Float64] {
    type O = ##java.lang.Double
    pub def toJava(x: Float64): ##java.lang.Double \ IO =
        checked_ecast(ToJava.float64ToJava(x))
}

instance ToJava[BigInt] {
    type O = ##java.math.BigInteger
    pub def toJava(x: BigInt): ##java.math.BigInteger \ IO =
        checked_ecast(identity(x))
}

instance ToJava[BigDecimal] {
    type O = ##java.math.BigDecimal
    pub def toJava(x: BigDecimal): ##java.math.BigDecimal \ IO =
        checked_ecast(identity(x))
}

mod ToJava {


    pub def boolToJava(b: Bool): ##java.lang.Boolean =
        import static java.lang.Boolean.valueOf(Bool): ##java.lang.Boolean \ {};
        valueOf(b)


    pub def charToJava(c: Char): ##java.lang.Character =
        import static java.lang.Character.valueOf(Char): ##java.lang.Character \ {};
        valueOf(c)

    pub def int8ToJava(i: Int8): ##java.lang.Byte =
        import static java.lang.Byte.valueOf(Int8): ##java.lang.Byte \ {};
        valueOf(i)

    pub def int16ToJava(i: Int16): ##java.lang.Short =
        import static java.lang.Short.valueOf(Int16): ##java.lang.Short \ {};
        valueOf(i)

    pub def int32ToJava(i: Int32): ##java.lang.Integer =
        import static java.lang.Integer.valueOf(Int32): ##java.lang.Integer \ {};
        valueOf(i)

    pub def int64ToJava(i: Int64): ##java.lang.Long =
        import static java.lang.Long.valueOf(Int64): ##java.lang.Long \ {};
        valueOf(i)

    pub def float32ToJava(d: Float32): ##java.lang.Float =
        import static java.lang.Float.valueOf(Float32): ##java.lang.Float \ {};
        valueOf(d)

    pub def float64ToJava(d: Float64): ##java.lang.Double =
        import static java.lang.Double.valueOf(Float64): ##java.lang.Double \ {};
        valueOf(d)

}
