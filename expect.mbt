///|
struct Expect[T] {
  received : T
  reversed : Bool
  loc : SourceLoc
  message : String
}

///| `expect` that works like [Jest/Vitest's expect](https://jestjs.io/docs/expect).
/// 
/// # Examples
///
/// ```mbt
/// // Basic equality
/// expect(123).to_be(123);
/// expect("hello").equal("hello");
/// expect("hello").not().equal("world");
///
/// // Numeric comparisons
/// expect(123).to_be_greater_than(5);
/// expect(123).to_be_less_than(200);
/// expect(123).to_be_greater_than_or_equal(123);
/// expect(123).to_be_less_than_or_equal(123);
///
/// // Boolean assertions
/// expect(true).to_be_truthy();
/// expect(false).to_be_falsy();
///
/// // String matching
/// expect("hello world").to_match("world");
/// expect("hello").not().to_match("world");
///
/// // Option assertions
/// let some_val : Option[Int] = Some(1);
/// let none_val : Option[Int] = None;
/// expect(some_val).to_be_some();
/// expect(none_val).to_be_none();
///
/// // Result assertions
/// let ok_val : Result[Int, String] = Ok(1);
/// let err_val : Result[Int, String] = Err("error");
/// expect(ok_val).to_be_ok();
/// expect(err_val).to_be_err();
///
/// // Array assertions
/// expect([1, 2, 3]).to_contain(2);
/// expect([1, 2, 3]).not().to_contain(4);
///
/// // Length assertions
/// expect("hello").to_have_length(5);
/// expect([1, 2, 3]).to_have_length(3);
///
/// // Floating point comparisons
/// expect(1.0).close_to(1.0001, 0.001);
/// ```
pub fn expect[T](
  t : T,
  loc~ : SourceLoc = _,
  message~ : String = ""
) -> Expect[T] {
  { received: t, reversed: false, loc, message }
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
    message: self.message,
  }
}

///|
pub fn to_be[T : Eq + Show](self : Expect[T], expected : T) -> Unit {
  equal(self, expected)
}

///|
pub fn to_be_truthy(self : Expect[Bool]) -> Unit {
  match self.reversed {
    true =>
      if self.received == true {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to be falsy").red().to_string()
        println(msg)
        print_loc(self)
      }
    false =>
      if self.received == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to be truthy").red().to_string()
        println(msg)
        print_loc(self)
      }
  }
}

///|
pub fn to_be_falsy(self : Expect[Bool]) -> Unit {
  self.not().to_be_truthy()
}

///|
fn print_loc[T](self : Expect[T]) -> Unit {
  let s = Formated::format(
      "at " +
      Formated::format(self.loc.to_string()).underline().blue().to_string(),
    )
    .blue()
    .to_string()
  if self.message.length() > 0 {
    let m = "Message"
    let m = Formated::format(m).bold().red().to_string()
    println("\{m}: \{Formated::format(self.message).red().to_string()}")
  }
  println(s)
}

///|
pub fn equal[T : Eq + Show](self : Expect[T], expected : T) -> Unit {
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
        abort("")
      }
  }
}

///|
fn contains(s : String, sub : String) -> Bool {
  let mut i = 0
  let mut j = 0
  while i < s.length() {
    if s[i] == sub[j] {
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
pub fn to_match(self : Expect[String], expected : String) -> Unit {
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
        abort("")
      }
  }
}

///|
pub fn to_be_none[T : Show](self : Expect[T?]) -> Unit {
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
        abort("")
      }
  }
}

///|
pub fn to_be_some[T : Show](self : Expect[T?]) -> Unit {
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
        abort("")
      }
  }
}

///|
pub fn to_be_ok[T : Show, D : Show](self : Expect[Result[T, D]]) -> Unit {
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
        abort("")
      }
  }
}

///|
pub fn to_be_err[T : Show, D : Show](self : Expect[Result[T, D]]) -> Unit {
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
        abort("")
      }
  }
}

///|
pub fn to_contain[T : Eq + Show](self : Expect[Array[T]], v : T) -> Unit {
  let result = self.received.contains(v)
  match self.reversed {
    false =>
      if result == false {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" to contain ").red().to_string() +
          Formated::format(debug_string(v)).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(Formated::format("- " + debug_string(v)).yellow())
        println(Formated::format("+ " + debug_string(self.received)).green())
        println("")
        abort("")
      }
    true =>
      if result {
        let msg = Formated::format("AssertionError: ").bold().red().to_string() +
          Formated::format("expected ").red().to_string() +
          Formated::format(debug_string(self.received)).green().to_string() +
          Formated::format(" not to contain ").red().to_string() +
          Formated::format(debug_string(v)).yellow().to_string()
        println(msg)
        print_loc(self)
        println("")
        println(Formated::format("- Expected: ").yellow())
        println(Formated::format("+ Received: ").green())
        println("")
        println(Formated::format("- " + debug_string(v)).yellow())
        println(Formated::format("+ " + debug_string(self.received)).green())
        println("")
        abort("")
      }
  }
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
  tolerance~ : Double = 0.000001
) -> Unit {
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
        abort("")
      }
  }
}

///|
pub fn to_have_length[T : HasLength + Show](
  self : Expect[T],
  expected : Int
) -> Unit {
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
        abort("")
      }
  }
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
) -> Unit {
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
    abort("")
  }
}

///|
pub fn to_be_greater_than[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Unit {
  expect_cmp(self, expected, CmpSymbol::Greater)
}

///|
pub fn to_be_less_than[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Unit {
  expect_cmp(self, expected, CmpSymbol::Less)
}

///|
pub fn to_be_less_than_or_equal[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Unit {
  expect_cmp(self, expected, CmpSymbol::LessOrEqual)
}

///|
pub fn to_be_greater_than_or_equal[T : Show + Compare](
  self : Expect[T],
  expected : T
) -> Unit {
  expect_cmp(self, expected, CmpSymbol::GreaterOrEqual)
}

///|
pub fn todo[T](reason~ : String = "", loc~ : SourceLoc = _) -> T {
  let msg = Formated::format("TODO: ").bold().red().to_string() +
    Formated::format(reason).yellow().to_string() +
    " at " +
    Formated::format(loc.to_string()).blue().to_string()
  println(msg)
  abort(msg)
}

///|
pub fn not_implemented[T](reason~ : String = "", loc~ : SourceLoc = _) -> T {
  let msg = Formated::format("Not implemented: ").bold().red().to_string() +
    Formated::format(reason).yellow().to_string() +
    " at " +
    Formated::format(loc.to_string()).blue().to_string()
  println(msg)
  abort(msg)
}

///|
pub fn panic[T](reason~ : String = "", loc~ : SourceLoc = _) -> T {
  let msg = Formated::format("Panic: ").bold().red().to_string() +
    Formated::format(reason).yellow().to_string() +
    " at " +
    Formated::format(loc.to_string()).blue().to_string()
  println(msg)
  abort(msg)
}
