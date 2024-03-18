# expect for MoonBit

`expect` that works like [Jest/Vitest's expect](https://jestjs.io/docs/expect).

You can use it to create various assertions easily.

# Example Usage

```
expect("hello").equal("hello")
expect("hello").not().equal("hello") // abort
expect("hello").equal("hello1") // abort
expect("hello").not().equal("hello1") 

let a : Option[Int] = Some(1)
let b : Option[Int] = None
expect(a).to_be_some() 
expect(b).to_be_none() 

expect("hello").to_have_length(5)
expect("hello").not().to_have_length(6)

expect(1).to_be_less_than(4)

let a : Result[Int, Int] = Ok(1)
let b : Result[Int, Int] = Err(1)
expect(a).to_be_ok()
expect(b).to_be_err()

expect(1.0).close_to(1.0, 0.1)
```

## Example Error Messages

```
AssertionError: expected 1.0 to be close to 1.2 (±0.1)

- Expected: 
+ Received: 

- 1.2
+ 1.0
```

```
AssertionError: expected "hello" to equal "hello1"

- Expected: 
+ Received: 

- "hello1"
+ "hello"
```
