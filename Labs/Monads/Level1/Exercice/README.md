# Exercise Level 1: Simplify code with Option&lt;T&gt;

**Problem to solve:**
You have this function that does many null checks and becomes hard to read:

```csharp
string? GetName(int id)
{
    var user = GetUser(id);
    if (user == null) return null;
    if (string.IsNullOrWhiteSpace(user.Name)) return null;
    return user.Name.ToUpper();
}
```

**Step 1: Create basic Option types**
Start by creating:

- Abstract class `Option<T>` with `HasValue` property and `Value` property
- Class `Some<T>` that contains a value
- Class `None<T>` that represents no value
- Static class `Option` with methods `Some<T>(value)` and `None<T>()`

**Step 2: Add Map method**
Add a `Map` method that transforms the value if present:

```csharp
var some = Option.Some(5);
var result = some.Map(x => x * 2); // Contains 10
var none = Option.None<int>();
var result2 = none.Map(x => x * 2); // Still None
```

**Step 3: Add Bind method**
Add a `Bind` method for chaining operations that return Option:

```csharp
var result = Option.Some("hello")
    .Bind(s => s.Length > 3 ? Option.Some(s.ToUpper()) : Option.None<string>());
```

**Final goal:**
Use your Option type to rewrite the original function:

```csharp
Option<string> GetNameWithOption(int id)
{
    return Option.FromNullable(GetUser(id))
        .Bind(user => string.IsNullOrWhiteSpace(user.Name) 
            ? Option.None<string>() 
            : Option.Some(user.Name))
        .Map(name => name.ToUpper());
}
```

**Bonus:** Add a `FromNullable` method to easily convert nullable references to Option.
