///|
struct Expect[T] {
  received : T
  reversed : Bool
  loc : SourceLoc
}

///|
pub let testing_by_self : Array[Bool] = [false]

///| `expect` that works like [Jest/Vitest's expect](https://jestjs.io/docs/expect).
/// 
/// # Examples
///
/// ```mbt
/// expect(123).to_be_greater_than(5);
/// expect(123).not().to_be_greater_than(125);
/// expect(1).to_be_greater_than(2); // This will abort
/// // AssertionError: expected 1 to be > 4
/// ```
pub fn expect[T](t : T, loc~ : SourceLoc = _) -> Expect[T] {
  { received: t, reversed: false, loc }
}

///|
pub fn not[T](self : Expect[T]) -> Expect[T] {
  {
    received: self.received,
    reversed: if self.reversed {
      false
    } else {
      true
    },
    loc: self.loc,
  }
}

///|
pub fn to_be[T : Eq + Show](self : Expect[T], expected : T) -> Bool {
  equal(self, expected)
}

///|
fn print_loc[T](self : Expect[T]) -> Unit {
  let s = Formated::format(
      "at " +
      Formated::format(self.loc.to_string()).underline().blue().to_string(),
    )
    .blue()
    .to_string()
  println("\{s}")
}

///|
pub fn equal[T : Eq + Show](self : Expect[T], expected : T) -> Bool {
  match self.reversed {
    false =>
      if self.received != expected {
        let received = self.received
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(received.to_string()).green().to_string() +
          Formated::format(" to equal ").red().to_string() +
          Formated::format(expected.to_string()).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(Formated::format("- " + debug_string(expected)).yellow())
        println(Formated::format("+ " + debug_string(received)).green())
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if self.received == expected {
        let received = self.received
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(received.to_string()).green().to_string() +
          Formated::format(" to not equal ").red().to_string() +
          Formated::format(expected.to_string()).green().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          " " + Formated::format(debug_string(received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
pub fn includes[T : Eq + Show](self : Expect[Iter[T]], v : T) -> Bool {
  fn has(arr : Iter[T], v : T) -> Bool {
    for a in arr {
      if a == v {
        return true
      }
    }
    false
  }

  let has = has(self.received, v)
  match self.reversed {
    false =>
      if has == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to include ").red().to_string() +
          Formated::format(debug_string(v)).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(
          Formated::format("- [..., " + debug_string(v) + ", ...]").yellow(),
        )
        println(Formated::format("+ " + debug_string(self.received)).green())
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if has {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to not include ").red().to_string() +
          Formated::format(debug_string(v)).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
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

///|
pub fn to_match(self : Expect[String], expected : String) -> Bool {
  let has = contains(self.received, expected)
  match self.reversed {
    false =>
      if has == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(self.received.to_string()).green().to_string() +
          Formated::format(" to include ").red().to_string() +
          Formated::format(expected.to_string()).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(
          Formated::format("- [..., " + debug_string(expected) + ", ...]").yellow(),
        )
        println(Formated::format("+ " + debug_string(self.received)).green())
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if has {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(self.received.to_string()).green().to_string() +
          Formated::format(" to not include ").red().to_string() +
          Formated::format(expected.to_string()).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
pub fn to_be_none[T : Show](self : Expect[T?]) -> Bool {
  let is_none = match self.received {
    None => true
    Some(_) => false
  }
  match self.reversed {
    false =>
      if is_none == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to be None").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if is_none {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" not to be None").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
pub fn to_be_some[T : Show](self : Expect[T?]) -> Bool {
  let is_some = match self.received {
    Some(_) => true
    None => false
  }
  match self.reversed {
    false =>
      if is_some == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to be Some").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if is_some {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" not to be Some").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
pub fn to_be_ok[T : Show, D : Show](self : Expect[Result[T, D]]) -> Bool {
  let is_ok = match self.received {
    Ok(_) => true
    Err(_) => false
  }
  match self.reversed {
    false =>
      if is_ok == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to be Ok").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          Formated::format("  " + debug_string(self.received))
          .green()
          .to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if is_ok {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" not to be Ok").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
pub fn to_be_err[T : Show, D : Show](self : Expect[Result[T, D]]) -> Bool {
  let is_err = match self.received {
    Err(_) => true
    Ok(_) => false
  }
  match self.reversed {
    false =>
      if is_err == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to be Err").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if is_err {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" not to be Err").red().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
fn abs(a : Double) -> Double {
  if a < 0.0 {
    -a
  } else {
    a
  }
}

///|
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
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(self.received.to_string()).green().to_string() +
          Formated::format(" to be close to ").red().to_string() +
          Formated::format(target.to_string()).yellow().to_string() +
          Formated::format(" (±" + tolerance.to_string() + ")")
          .red()
          .to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(Formated::format("- " + debug_string(target)).yellow())
        println(Formated::format("+ " + debug_string(self.received)).green())
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if result {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(self.received.to_string()).green().to_string() +
          Formated::format(" not to be close to ").red().to_string() +
          Formated::format(target.to_string()).yellow().to_string() +
          Formated::format(" (±" + tolerance.to_string() + ")")
          .red()
          .to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
pub fn to_have_length[T : HasLength + Show](
  self : Expect[T],
  expected : Int
) -> Bool {
  let length = self.received.length()
  match self.reversed {
    false =>
      if length != expected {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to have length ").red().to_string() +
          Formated::format(expected.to_string()).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(Formated::format("- " + debug_string(expected)).yellow())
        println(Formated::format("+ " + debug_string(length)).green())
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
    true =>
      if length == expected {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" not to have length ").red().to_string() +
          Formated::format(expected.to_string()).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("  Received: ").green())
        println("")
        println(
          "  " +
          Formated::format(debug_string(self.received)).green().to_string(),
        )
        println("")
        if testing_by_self.get(0).unwrap() == true {
          return false
        }
        abort("")
      }
  }
  true
}

///|
priv enum CmpSymbol {
  Greater
  Less
  GreaterOrEqual
  LessOrEqual
}

///|
fn reverse(self : CmpSymbol) -> CmpSymbol {
  match self {
    CmpSymbol::Greater => CmpSymbol::LessOrEqual
    CmpSymbol::Less => CmpSymbol::GreaterOrEqual
    CmpSymbol::GreaterOrEqual => CmpSymbol::Less
    CmpSymbol::LessOrEqual => CmpSymbol::Greater
  }
}

///|
fn to_string(self : CmpSymbol) -> String {
  match self {
    CmpSymbol::Greater => ">"
    CmpSymbol::Less => "<"
    CmpSymbol::GreaterOrEqual => ">="
    CmpSymbol::LessOrEqual => "<="
  }
}

///|
fn assert_cmp(self : CmpSymbol, cmp : Int) -> Bool {
  match self {
    CmpSymbol::Greater => cmp > 0
    CmpSymbol::Less => cmp < 0
    CmpSymbol::GreaterOrEqual => cmp >= 0
    CmpSymbol::LessOrEqual => cmp <= 0
  }
}

///|
fn expect_cmp[T : Show + Compare](
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
    let msg = Formated::format("AssertionError: ").bold().red().to_string() +
      Formated::format("expected ").red().to_string() +
      Formated::format(debug_string(received.received)).green().to_string() +
      Formated::format(" to be " + symbol_str + " ").red().to_string() +
      Formated::format(debug_string(expected)).yellow().to_string()
    println(msg)
    print_loc(received)
    if testing_by_self.get(0).unwrap() == true {
      return false
    }
    abort("")
  }
  is_correct
}

///|
pub fn to_be_greater_than[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::Greater)
}

///|
pub fn to_be_less_than[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::Less)
}

///|
pub fn to_be_less_than_or_equal[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::LessOrEqual)
}

///|
pub fn to_be_greater_than_or_equal[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Bool {
  expect_cmp(self, expected, CmpSymbol::GreaterOrEqual)
}

///|
pub fn todo(
  reason~ : String = "",
  loc~ : SourceLoc = _,
  to_abort~ : Bool = true
) -> Unit {
  let msg = Formated::format("TODO: ").bold().red().to_string() +
    Formated::format(reason).yellow().to_string() +
    " at " +
    Formated::format(loc.to_string()).blue().to_string()
  println(msg)
  if to_abort {
    abort(msg)
  }
}

///|
pub fn not_implemented(
  reason~ : String = "",
  loc~ : SourceLoc = _,
  to_abort~ : Bool = true
) -> Unit {
  let msg = Formated::format("Not implemented: ").bold().red().to_string() +
    Formated::format(reason).yellow().to_string() +
    " at " +
    Formated::format(loc.to_string()).blue().to_string()
  println(msg)
  if to_abort {
    abort(msg)
  }
}

///|
pub fn panic(
  reason~ : String = "",
  loc~ : SourceLoc = _,
  to_abort~ : Bool = true
) -> Unit {
  let msg = Formated::format("Panic: ").bold().red().to_string() +
    Formated::format(reason).yellow().to_string() +
    " at " +
    Formated::format(loc.to_string()).blue().to_string()
  println(msg)
  if to_abort {
    abort(msg)
  }
}
