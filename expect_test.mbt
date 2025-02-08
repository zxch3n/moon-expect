///|
fn init {
  @expect.testing_by_self[0] = true
}

///|
pub fn assert(v : Bool) -> Unit {
  if v == false {
    abort("test assertion failed")
  }
}

test "equal" {
  assert(@expect.expect(1).equal(1) == true)
  assert(@expect.expect("hello").equal("hello") == true)
  assert(@expect.expect("hello").not().equal("hello") == false)
  assert(@expect.expect("hello").equal("hello1") == false)
  assert(@expect.expect("hello").not().equal("hello1") == true)
}

test "includes" {
  let list = [1, 2, 3, 4]
  assert(@expect.expect(list.iter()).includes(2))
  assert(@expect.expect(list.iter()).includes(5) == false)
  ()
}

test "includes_str" {
  assert(@expect.expect("abcd").to_match("bc"))
  assert(@expect.expect("abcd").not().to_match("bc") == false)
  assert(@expect.expect("12345").to_match("12345"))
  assert(@expect.expect("12345").to_match("123456") == false)
  ()
}

test "closeTo" {
  assert(@expect.expect(1.0).close_to(1.0, 0.1))
  assert(@expect.expect(1.0).not().close_to(1.0, 0.1) == false)
  assert(@expect.expect(1.0).close_to(1.2, 0.1) == false)
  assert(@expect.expect(1.0).not().close_to(1.2, 0.1))
  ()
}

test "inc" {
  let f = called()
  assert(f() == 1)
  assert(f() == 2)
  assert(f() == 3)
  ()
}

test "option" {
  let a : Int? = Some(1)
  let b : Int? = None
  assert(@expect.expect(a).to_be_none() == false)
  assert(@expect.expect(b).to_be_some() == false)
  assert(@expect.expect(a).not().to_be_some() == false)
  assert(@expect.expect(b).not().to_be_none() == false)
}

test "expect ok" {
  let a : Result[Int, Int] = Ok(1)
  let b : Result[Int, Int] = Err(12)
  assert(@expect.expect(a).to_be_ok())
  assert(@expect.expect(b).to_be_err())
  assert(@expect.expect(a).not().to_be_ok() == false)
  assert(@expect.expect(b).not().to_be_err() == false)
  assert(@expect.expect(a).to_be_err() == false)
  assert(@expect.expect(b).to_be_ok() == false)
}

test "length" {
  assert(@expect.expect("hello").to_have_length(5))
  assert(@expect.expect("hello").to_have_length(6) == false)
  assert(@expect.expect("hello").not().to_have_length(5) == false)
}

test "cmp" {
  assert(@expect.expect(1).to_be_less_than(4))
  assert(@expect.expect(1).to_be_less_than(0) == false)
  assert(@expect.expect(1).to_be_greater_than(4) == false)
  assert(@expect.expect(1).to_be_greater_than_or_equal(2) == false)
  assert(@expect.expect(1).to_be_greater_than_or_equal(1))
  assert(@expect.expect(1).not().to_be_greater_than_or_equal(1) == false)
}

test "panic todo" {
  @expect.todo(reason="reason")
}

test "panic not_implemented" {
  @expect.not_implemented(reason="reason")
}

test "panic_test" {
  @expect.panic(reason="reason")
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
