///|
pub trait HasLength {
  length(Self) -> Int
}

///|
pub impl HasLength for String with length(self) { self.length() }

///|
pub impl[A] HasLength for Array[A] with length(self) { self.length() }

test "Array::length/empty_array" {
  let arr : Array[Int] = []
  inspect!(arr.length(), content="0")
}

test "Array::length/single_element" {
  let arr : Array[Int] = [1]
  inspect!(arr.length(), content="1")
}

test "Array::length/multiple_elements" {
  let arr : Array[Int] = [1, 2, 3, 4, 5]
  inspect!(arr.length(), content="5")
}

///|
pub impl[A] HasLength for List[A] with length(self) { self.length() }
