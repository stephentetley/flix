@test
pub def testTypeParamElision01(): Int = f(1 :: 2 :: Nil, "Hello" :: Nil)

pub def f(_x: List[_], _y: List[_]): Int = 123
