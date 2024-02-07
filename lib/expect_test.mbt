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

fn called() -> () -> Int {
  let mut i = 0
  fn f() -> Int {
    i = i + 1
    i
  }

  f
}
