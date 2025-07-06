# Exercise Level 2: Chaining Operations with Option

**Objective:**
Use the `Option<T>` monad to chain multiple operations that may fail.

- Write a function that takes a string, tries to parse it as an integer, then computes its inverse (1/x).
- Use only the `Option` monad to handle failure cases (parse or division by zero).
- Use `Bind` to chain the operations.

**Example usage:**
```csharp
Option<double> SafeInverse(string input)
```

**Goal:** Understand how the Option monad allows chaining operations without explicit error handling.
