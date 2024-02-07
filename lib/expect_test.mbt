fn init {
  testing_by_self.set(0, true)
}

pub fn assert(v : Bool) {
  if v == false {
    abort("test assertion failed")
  }
}

test "equal" {
  assert(expect("hello").equal("hello") == true)
  assert(expect("hello").not().equal("hello") == false)
  assert(expect("hello").equal("hello1") == false)
  assert(expect("hello").not().equal("hello1") == true)
}

test "includes" {
  let list : List[Int] = Cons(1, Cons(2, Cons(3, Nil)))
  assert(expect(list).includes(2))
  assert(expect(list).includes(5) == false)
  ()
}

test "includes_str" {
  assert(expect("abcd").to_match("bc"))
  assert(expect("abcd").not().to_match("bc") == false)
  assert(expect("12345").to_match("12345"))
  assert(expect("12345").to_match("123456") == false)
  ()
}

test "closeTo" {
  assert(expect(1.0).close_to(1.0, 0.1))
  assert(expect(1.0).not().close_to(1.0, 0.1) == false)
  assert(expect(1.0).close_to(1.2, 0.1) == false)
  assert(expect(1.0).not().close_to(1.2, 0.1))
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
  let a : Option[Int] = Some(1)
  let b : Option[Int] = None
  assert(expect(a).to_be_none() == false)
  assert(expect(b).to_be_some() == false)
  assert(expect(a).not().to_be_some() == false)
  assert(expect(b).not().to_be_none() == false)
}

test "expect ok" {
  let a : Result[Int, Int] = Ok(1)
  let b : Result[Int, Int] = Err(12)
  assert(expect(a).to_be_ok())
  assert(expect(b).to_be_err())
  assert(expect(a).not().to_be_ok() == false)
  assert(expect(b).not().to_be_err() == false)
  assert(expect(a).to_be_err() == false)
  assert(expect(b).to_be_ok() == false)
}

test "length" {
  assert(expect("hello").to_have_length(5))
  assert(expect("hello").to_have_length(6) == false)
  assert(expect("hello").not().to_have_length(5) == false)
}

test "cmp" {
  assert(expect(1).to_be_less_than(4))
  assert(expect(1).to_be_less_than(0) == false)
  assert(expect(1).to_be_greater_than(4) == false)
  assert(expect(1).to_be_greater_or_equal_to(2) == false)
  assert(expect(1).to_be_greater_or_equal_to(1))
  assert(expect(1).not().to_be_greater_or_equal_to(1) == false)
}

fn called() -> () -> Int {
  let mut i = 0
  fn f() -> Int {
    i = i + 1
    i
  }

  f
}
