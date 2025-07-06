# Exercise Level 4: Monad Composition and Asynchronous Effect Handling (Advanced)

**Objective:**
Implement a custom monad for handling asynchronous effects (`Async<T>`) and compose it with the `Option` and `Result` monads.

- Create an `Async<T>` monad that wraps an asynchronous task (`Task<T>`).
- Add the methods `Map` and `Bind` to allow asynchronous composition.
- Write a function that combines `Async`, `Option`, and `Result` to perform an asynchronous operation that may fail or return no value.
- Example: Fetch a remote resource, parse the result, then perform a calculation, handling all failure cases.

**Goal:** Understand monad composition and advanced effect management (asynchrony, errors, missing values).
