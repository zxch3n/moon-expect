struct Expect[T] {
  received : T
  reversed : Bool
}

let testing_by_self : Array[Bool] = [false]

/// `expect` that works like [Jest/Vitest's expect](https://jestjs.io/docs/expect).
/// 
/// # Examples
///
/// ```mbt
/// expect(123).to_be_greater_than(5);
/// expect(123).not().to_be_greater_than(125);
/// expect(1).to_be_greater_than(2); // This will abort
/// // AssertionError: expected 1 to be > 4
/// ```
pub fn expect[T](t : T) -> Expect[T] {
  { received: t, reversed: false }
}

pub fn not[T](self : Expect[T]) -> Expect[T] {
  {
    received: self.received,
    reversed: if self.reversed {
      false
    } else {
      true
    },
  }
}

pub fn to_be[T : Eq + Debug](self : Expect[T], expected : T) -> Bool {
  equal(self, expected)
}

pub fn equal[T : Eq + Debug](self : Expect[T], expected : T) -> Bool {
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

pub fn includes[T : Eq + Debug](self : Expect[List[T]], v : T) -> Bool {
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

fn contains(s : String, sub : String) -> Bool {
  let mut i = 0
  let mut j = 0
  while i < s.length() {
    if s.get(i) == sub.get(j) {
      j = j + 1
      if j == sub.length() {
        return true
      }
    } else {
      j = 0
    }
    i = i + 1
  }
  false
}

pub fn to_match(self : Expect[String], expected : String) -> Bool {
  let has = contains(self.received, expected)
  match self.reversed {
    false =>
      if has == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected the string to include " + debug_string(expected),
          ).red().to_string()
        println(msg)
        println("")
        print_string(format("Expected Substring: ").yellow().to_string())
        println(format(debug_string(expected)).yellow())
        print_string(format("Received          : ").red().to_string())
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
            "expected the string to not include " + debug_string(expected),
          ).red().to_string()
        println(msg)
        println("")
        print_string(format("Expected Substring: ").yellow().to_string())
        println(format(debug_string(expected)).yellow())
        print_string(format("Received          : ").red().to_string())
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

pub fn to_be_none[T : Debug](self : Expect[Option[T]]) -> Bool {
  let is_none = match self.received {
    None => true
    Some(_) => false
  }
  match self.reversed {
    false =>
      if is_none == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to be None",
          ).red().to_string()
        println(msg)
        println("")
        print_string(format("Received: ").red().to_string())
        println(format(debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if is_none {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to not be None",
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

pub fn to_be_some[T : Debug](self : Expect[Option[T]]) -> Bool {
  let is_some = match self.received {
    Some(_) => true
    None => false
  }
  match self.reversed {
    false =>
      if is_some == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to be Some",
          ).red().to_string()
        println(msg)
        println("")
        print_string(format("Received: ").red().to_string())
        println(format(debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if is_some {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to not be Some",
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

pub fn to_be_ok[T : Debug, D : Debug](self : Expect[Result[T, D]]) -> Bool {
  let is_ok = match self.received {
    Ok(_) => true
    Err(_) => false
  }
  match self.reversed {
    false =>
      if is_ok == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to be Ok",
          ).red().to_string()
        println(msg)
        println("")
        print_string(format("Received: ").red().to_string())
        println(format(debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if is_ok {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to not be Ok",
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

pub fn to_be_err[T : Debug, D : Debug](self : Expect[Result[T, D]]) -> Bool {
  let is_err = match self.received {
    Err(_) => true
    Ok(_) => false
  }
  match self.reversed {
    false =>
      if is_err == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to be Err",
          ).red().to_string()
        println(msg)
        println("")
        print_string(format("Received: ").red().to_string())
        println(format(debug_string(self.received)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if is_err {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to not be Err",
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

fn abs(a : Double) -> Double {
  if a < 0.0 {
    -a
  } else {
    a
  }
}

pub fn close_to(
  self : Expect[Double],
  target : Double,
  tolerance : Double
) -> Bool {
  let diff = abs(self.received - target)
  let tolerance = abs(tolerance)
  let result = diff < tolerance
  match self.reversed {
    false =>
      if result == false {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected " + debug_string(self.received) + " to be close to " + debug_string(
              target,
            ) + " (±\(tolerance))",
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
            "expected " + debug_string(self.received) + " to not be close to " +
            debug_string(target) + " (±\(tolerance))",
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

pub fn to_have_length[T : HasLength + Debug](
  self : Expect[T],
  expected : Int
) -> Bool {
  let length = self.received.length()
  match self.reversed {
    false =>
      if length != expected {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected the length of " + debug_string(self.received) + " to be " +
            debug_string(expected),
          ).red().to_string()
        println(msg)
        println("")
        println(format("- Expected: ").yellow())
        println(format("+ Received: ").red())
        println("")
        println(format("- " + debug_string(expected)).yellow())
        println(format("+ " + debug_string(length)).red())
        println("\n")
        if testing_by_self.get(0) == true {
          return false
        }
        abort("")
      }
    true =>
      if length == expected {
        let msg = format("AssertionError: ").bold().red().to_string() + format(
            "expected the length of " + debug_string(self.received) + " to not be " +
            debug_string(expected),
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

priv enum CmpSymbol {
  Greater
  Less
  GreaterOrEqual
  LessOrEqual
}

fn reverse(self : CmpSymbol) -> CmpSymbol {
  match self {
    CmpSymbol::Greater => CmpSymbol::LessOrEqual
    CmpSymbol::Less => CmpSymbol::GreaterOrEqual
    CmpSymbol::GreaterOrEqual => CmpSymbol::Less
    CmpSymbol::LessOrEqual => CmpSymbol::Greater
  }
}

fn to_string(self : CmpSymbol) -> String {
  match self {
    CmpSymbol::Greater => ">"
    CmpSymbol::Less => "<"
    CmpSymbol::GreaterOrEqual => ">="
    CmpSymbol::LessOrEqual => "<="
  }
}

fn assert_cmp(self : CmpSymbol, cmp : Int) -> Bool {
  match self {
    CmpSymbol::Greater => cmp > 0
    CmpSymbol::Less => cmp < 0
    CmpSymbol::GreaterOrEqual => cmp >= 0
    CmpSymbol::LessOrEqual => cmp <= 0
  }
}

fn expect_cmp[T : Debug + Compare](
  received : Expect[T],
  expected : T,
  expected_symbol : CmpSymbol
) -> Bool {
  let mut expected_symbol = expected_symbol
  if received.reversed {
    expected_symbol = expected_symbol.reverse()
  }
  let cmp = received.received.compare(expected)
  let is_correct = expected_symbol.assert_cmp(cmp)
  if is_correct == false {
    let symbol_str = expected_symbol.to_string()
    let msg = format("AssertionError: ").bold().red().to_string() + format(
        "expected " + debug_string(received.received) + " to be \(symbol_str) " +
        debug_string(expected),
      ).red().to_string()
    println(msg)
    println("\n")
    if testing_by_self.get(0) == true {
      return false
    }
    abort("")
  }
  is_correct
}

pub fn to_be_greater_than[T : Debug + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::Greater)
}

pub fn to_be_less_than[T : Debug + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::Less)
}

pub fn to_be_less_than_or_equal[T : Debug + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::LessOrEqual)
}

pub fn to_be_greater_than_or_equal[T : Debug + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::GreaterOrEqual)
}
