///|
pub fn expect[T](t : T, loc~ : SourceLoc = _) -> @lib.Expect[T] {
  @lib.expect(t, loc~)
}
