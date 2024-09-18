fn init {
  @lib.testing_by_self[0] = true
}

pub fn assert(v : Bool) -> Unit {
  if v == false {
    abort("test assertion failed")
  }
}

test "equal" {
  assert(@lib.expect(1).equal(1) == true)
  assert(@lib.expect("hello").equal("hello") == true)
  assert(@lib.expect("hello").not().equal("hello") == false)
  assert(@lib.expect("hello").equal("hello1") == false)
  assert(@lib.expect("hello").not().equal("hello1") == true)
}

test "includes" {
  let list = [1, 2, 3, 4]
  assert(@lib.expect(list.iter()).includes(2))
  assert(@lib.expect(list.iter()).includes(5) == false)
  ()
}

test "includes_str" {
  assert(@lib.expect("abcd").to_match("bc"))
  assert(@lib.expect("abcd").not().to_match("bc") == false)
  assert(@lib.expect("12345").to_match("12345"))
  assert(@lib.expect("12345").to_match("123456") == false)
  ()
}

test "closeTo" {
  assert(@lib.expect(1.0).close_to(1.0, 0.1))
  assert(@lib.expect(1.0).not().close_to(1.0, 0.1) == false)
  assert(@lib.expect(1.0).close_to(1.2, 0.1) == false)
  assert(@lib.expect(1.0).not().close_to(1.2, 0.1))
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
  assert(@lib.expect(a).to_be_none() == false)
  assert(@lib.expect(b).to_be_some() == false)
  assert(@lib.expect(a).not().to_be_some() == false)
  assert(@lib.expect(b).not().to_be_none() == false)
}

test "expect ok" {
  let a : Result[Int, Int] = Ok(1)
  let b : Result[Int, Int] = Err(12)
  assert(@lib.expect(a).to_be_ok())
  assert(@lib.expect(b).to_be_err())
  assert(@lib.expect(a).not().to_be_ok() == false)
  assert(@lib.expect(b).not().to_be_err() == false)
  assert(@lib.expect(a).to_be_err() == false)
  assert(@lib.expect(b).to_be_ok() == false)
}

test "length" {
  assert(@lib.expect("hello").to_have_length(5))
  assert(@lib.expect("hello").to_have_length(6) == false)
  assert(@lib.expect("hello").not().to_have_length(5) == false)
}

test "cmp" {
  assert(@lib.expect(1).to_be_less_than(4))
  assert(@lib.expect(1).to_be_less_than(0) == false)
  assert(@lib.expect(1).to_be_greater_than(4) == false)
  assert(@lib.expect(1).to_be_greater_than_or_equal(2) == false)
  assert(@lib.expect(1).to_be_greater_than_or_equal(1))
  assert(@lib.expect(1).not().to_be_greater_than_or_equal(1) == false)
}

fn called() -> () -> Int {
  let mut i = 0
  fn f() -> Int {
    i = i + 1
    i
  }

  f
}
