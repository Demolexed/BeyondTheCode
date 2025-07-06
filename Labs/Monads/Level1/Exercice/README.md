# Exercise Level 1: Implementing an Option Monad

**Objective:**
Implement an `Option<T>` monad in C# that represents a value that may be present (`Some`) or absent (`None`).

- Create a generic class `Option<T>` with two subclasses: `Some<T>` and `None<T>`.
- Add the methods `Map` and `Bind` (also called `FlatMap`).
- Add static methods `Option.Some(value)` and `Option.None<T>()` to create instances.

**Example usage:**
```csharp
var some = Option.Some(5);
var none = Option.None<int>();
var result = some.Map(x => x * 2); // Should contain 10
var result2 = none.Map(x => x * 2); // Should remain None
```

**Goal:** Understand the basic structure of a monad and its usefulness for handling missing values.
