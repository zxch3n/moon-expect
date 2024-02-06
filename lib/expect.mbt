pub struct ExpectObj[T] {
  src: T
} 

pub fn equal[T: Eq + Show + Debug](self: ExpectObj[T], received: T)  {
  if self.src != received {
    let expected = self.src;
    let msg = format("AssertionError: ").bold().red().to_string() + format("expected \(received) to equal \(expected)").red().to_string();
    println(msg);
    println("");
    println(format("- Expected: ").yellow())
    println(format("+ Received: ").red())
    println("");
    println(format("- " + debug_string(expected)).yellow())
    println(format("+ " + debug_string(received)).red());
    abort("\n");
  }
}

pub fn expect[T: Eq + Show](t: T) -> ExpectObj[T] {
  {
    src: t
  }
}
