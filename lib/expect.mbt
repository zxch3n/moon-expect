struct ExpectObj[T] {
  received : T
  reversed : Bool
}

let testing_by_self : Array[Bool] = [false]

pub fn equal[T : Eq + Show + Debug](self : ExpectObj[T], expected : T) -> Bool {
  match self.reversed {
    false =>
      if self.received != expected {
        let received = self.received
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(received) + " to equal " + debug_string(
              expected,
            ),
          ).red().to_string()
        println(msg)
        println("")
        println(format("- Expected: ").yellow())
        println(format("+ Received: ").red())
        println("")
        println(format("- " + debug_string(expected)).yellow())
        println(format("+ " + debug_string(received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if self.received == expected {
        let received = self.received
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(received) + " to not equal " + debug_string(
              expected,
            ),
          ).red().to_string()
        println(msg)
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
  }
  true
}

pub fn includes[T : Eq + Debug](self : ExpectObj[List[T]], v : T) -> Bool {
  fn has(arr : List[T], v : T) -> Bool {
    match arr {
      Nil => false
      Cons(h, t) => if h == v { true } else { has(t, v) }
    }
  }

  let has = has(self.received, v)
  match self.reversed {
    false =>
      if has == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected the list to include " + debug_string(v),
          ).red().to_string()
        println(msg)
        println("")
        println(format("Received: ").red())
        println(format(debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if has {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected the list to not include " + debug_string(v),
          ).red().to_string()
        println(msg)
        println("")
        println(format("Received: ").red())
        println(format(debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
  }
  true
}

fn abs(a: Double) -> Double {
  if a < 0.0 {
    -a
  } else {
    a
  }
}

fn pow(a: Double, b: Int) -> Double {
  let mut result = 1.0
  for i = 0 ;i < b; i = i + 1 {
    result = result * a
  }

  result
}

pub fn close_to(self: ExpectObj[Double], target: Double, digit: Int) -> Bool {
  let diff = abs((self.received - target));
  let acceptable_range = pow(0.1, digit);
  let result = diff < acceptable_range;
  match self.reversed {
    false =>
      if not(result) {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to be close to " + debug_string(
              target,
            ),
          ).red().to_string()
        println(msg)
        println("")
        println(format("- Expected: ").yellow())
        println(format("+ Received: ").red())
        println("")
        println(format("- " + debug_string(target)).yellow())
        println(format("+ " + debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if result {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to not be close to " + debug_string(
              target,
            ),
          ).red().to_string()
        println(msg)
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
  }
  true

}

pub fn expect[T : Eq + Show](t : T) -> ExpectObj[T] {
  { received: t, reversed: false }
}

pub fn not[T](self : ExpectObj[T]) -> ExpectObj[T] {
  {
    received: self.received,
    reversed: if self.reversed {
      false
    } else {
      true
    },
  }
}
