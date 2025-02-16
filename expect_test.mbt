///|
pub fn assert_(v : Bool) -> Unit {
  if v == false {
    abort("test assertion failed")
  }
}

///|
test "equal" {
  @expect.expect(1).equal(1)
  @expect.expect("hello").equal("hello")
  @expect.expect("hello").not().equal("hello1")
}

///|
test "panic equal" {
  @expect.expect("hello").not().equal("hello")
}

///|
test "panic equal 1" {
  @expect.expect("hello").equal("hello1")
}

///|
test "includes_str" {
  @expect.expect("abcd").to_match("bc")
  @expect.expect("12345").to_match("12345")
  ()
}

///|
test "panic includes_str" {
  @expect.expect("abcd").not().to_match("bc")
}

///|
test "panic includes_str 1" {
  @expect.expect("12345").to_match("123456")
}

///|
test "closeTo" {
  @expect.expect(1.0).close_to(1.0)
  ()
}

///|
test "panic closeTo" {
  @expect.expect(1.0).not().close_to(1.0)
}

///|
test "panic closeTo 1" {
  @expect.expect(1.0).close_to(1.2)
}

///|
test "inc" {
  let f = called()
  assert_(f() == 1)
  assert_(f() == 2)
  assert_(f() == 3)
  ()
}

///|
test "option" {
  let a : Int? = Some(1)
  let b : Int? = None
  @expect.expect(b).to_be_none()
  @expect.expect(a).to_be_some()
  ()
}

///|
test "panic option none" {
  let a : Int? = Some(1)
  @expect.expect(a).to_be_none()
}

///|
test "panic option some" {
  let b : Int? = None
  @expect.expect(b).to_be_some()
}

///|
test "panic option not some" {
  let a : Int? = Some(1)
  @expect.expect(a).not().to_be_some()
}

///|
test "panic option not none" {
  let b : Int? = None
  @expect.expect(b).not().to_be_none()
}

///|
test "expect ok" {
  let a : Result[Int, Int] = Ok(1)
  let b : Result[Int, Int] = Err(12)
  @expect.expect(a).to_be_ok()
  @expect.expect(b).to_be_err()
  ()
}

///|
test "panic expect ok not ok" {
  let a : Result[Int, Int] = Ok(1)
  @expect.expect(a).not().to_be_ok()
}

///|
test "panic expect ok not err" {
  let b : Result[Int, Int] = Err(12)
  @expect.expect(b).not().to_be_err()
}

///|
test "panic expect ok err" {
  let a : Result[Int, Int] = Ok(1)
  @expect.expect(a).to_be_err()
}

///|
test "panic expect ok ok" {
  let b : Result[Int, Int] = Err(12)
  @expect.expect(b).to_be_ok()
}

///|
test "length" {
  @expect.expect("hello").to_have_length(5)
  ()
}

///|
test "panic length" {
  @expect.expect("hello").to_have_length(6)
}

///|
test "panic length not" {
  @expect.expect("hello").not().to_have_length(5)
}

///|
test "cmp" {
  @expect.expect(1).to_be_less_than(4)
  @expect.expect(1).to_be_greater_than_or_equal(1)
  ()
}

///|
test "panic cmp less than" {
  @expect.expect(1).to_be_less_than(0)
}

///|
test "panic cmp greater than" {
  @expect.expect(1).to_be_greater_than(4)
}

///|
test "panic cmp greater than or equal" {
  @expect.expect(1).to_be_greater_than_or_equal(2)
}

///|
test "panic cmp not greater than or equal" {
  @expect.expect(1).not().to_be_greater_than_or_equal(1)
}

///|
test "panic todo" {
  @expect.todo(reason="reason")
}

///|
test "panic not_implemented" {
  @expect.not_implemented(reason="reason")
}

///|
test "panic_test" {
  @expect.panic(reason="reason")
}

///|
test "panic to_contain" {
  @expect.expect([1, 2, 3]).to_contain(4)
}

///|
test "panic to_be_truthy" {
  @expect.expect(true, message="Test Message").not().to_be_truthy()
}

///|
test "panic to_be_truthy" {
  @expect.expect(true).to_be_falsy()
}

///|
fn called() -> () -> Int {
  let mut i = 0
  fn f() -> Int {
    i = i + 1
    i
  }

  f
}
