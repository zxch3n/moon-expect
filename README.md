# expect for MoonBit

`expect` that works like [Jest/Vitest's expect](https://jestjs.io/docs/expect).

You can use it to create various assertions easily.

## Available Assertions

### Basic Equality

```mbt
expect(123).to_be(123)
expect("hello").equal("hello")
expect("hello").not().equal("world")
```

### Numeric Comparisons

```mbt
expect(123).to_be_greater_than(5)
expect(123).to_be_less_than(200)
expect(123).to_be_greater_than_or_equal(123)
expect(123).to_be_less_than_or_equal(123)
```

### Boolean Assertions

```mbt
expect(true).to_be_truthy()
expect(false).to_be_falsy()
```

### String Matching

```mbt
expect("hello world").to_match("world")
expect("hello").not().to_match("world")
```

### Option Type Assertions

```mbt
let some_val : Option[Int] = Some(1)
let none_val : Option[Int] = None
expect(some_val).to_be_some()
expect(none_val).to_be_none()
```

### Result Type Assertions

```mbt
let ok_val : Result[Int, String] = Ok(1)
let err_val : Result[Int, String] = Err("error")
expect(ok_val).to_be_ok()
expect(err_val).to_be_err()
```

### Array Assertions

```mbt
expect([1, 2, 3]).to_contain(2)
expect([1, 2, 3]).not().to_contain(4)
```

### Length Assertions

Works with strings, arrays, and any type that implements `HasLength`:

```mbt
expect("hello").to_have_length(5)
expect([1, 2, 3]).to_have_length(3)
```

### Floating Point Comparisons

```mbt
// Compare with tolerance (default tolerance is 0.000001)
expect(1.0).close_to(1.0001, 0.001)
```

### Negating Assertions

You can negate any assertion using `not()`:

```mbt
expect("hello").not().equal("world")
expect(5).not().to_be_greater_than(10)
expect([1, 2, 3]).not().to_contain(4)
```

## Error Messages

The library provides detailed error messages when assertions fail. Here are some
examples:

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

## Utility Functions

The library also provides some utility functions for development:

```mbt
// Mark code as TODO with an optional reason
todo("Implement this feature")

// Mark code as not implemented
not_implemented("This feature is planned for v2")

// Panic with a custom message
panic("Something went wrong")
```
