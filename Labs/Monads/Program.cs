using System;

using System;

using Monads.Level1;
using Monads.Level3;

class Program
{
    static void Main(string[] args)
    {
        // Exemple d'utilisation du Result Monad
        Result<int, string> ok = Result<int, string>.Ok(10);
        Result<int, string> error = Result<int, string>.ErrorResult("Erreur !");

        // Map
        var mapped = ok.Map(x => x * 2);
        var mappedError = error.Map(x => x * 2);

        // Bind
        var bound = ok.Bind(x => x > 5 ? Result<int, string>.Ok(x - 5) : Result<int, string>.ErrorResult("Trop petit"));
        var boundError = error.Bind(x => Result<int, string>.Ok(x - 5));

        Console.WriteLine($"ok: {((Ok<int, string>)ok).Value}");
        Console.WriteLine($"error: {error.Error}");
        Console.WriteLine($"mapped: {((Ok<int, string>)mapped).Value}");
        Console.WriteLine($"mappedError: {mappedError.Error}");
        Console.WriteLine($"bound: {((Ok<int, string>)bound).Value}");
        Console.WriteLine($"boundError: {boundError.Error}");
    }
}
