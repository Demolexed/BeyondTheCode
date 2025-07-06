# Exercise Level 3: Result Monad and Error Handling

**Objective:**
Implement a `Result<T, E>` monad that represents either a value (`Ok`) or an error (`Error`).

- Create a generic class `Result<T, E>` with two subclasses: `Ok<T, E>` and `Error<T, E>`.
- Add the methods `Map`, `Bind`, and a method to retrieve the error.
- Rewrite the previous exercise (SafeInverse) to return a `Result<double, string>` with an explicit error message.

**Goal:** Understand the difference between Option and Result, and how to propagate explicit errors.
