using System;
using System.Threading.Tasks;
using Monads.Level1;
using Monads.Level3;

namespace Monads.Level4 {
    public static class AsyncOptionResultComposition {
        public static Async<Result<double, string>> RemoteInverse(string input) {
            return new Async<Result<double, string>>(RemoteFetch(input)
                .ContinueWith(fetchTask =>
                {
                    var str = fetchTask.Result;
                    var opt = ParseInt(str);
                    if (opt is Some<int> some)
                    {
                        if (some.Value == 0)
                            return Result<double, string>.ErrorResult("Division par zéro");
                        return Result<double, string>.Ok(1.0 / some.Value);
                    }
                    return Result<double, string>.ErrorResult($"'{str}' n'est pas un entier valide");
                }));
        }

        private static Task<string> RemoteFetch(string input) {
            // Simule un appel distant asynchrone
            return Task.FromResult(input);
        }

        private static Option<int> ParseInt(string input) {
            if (int.TryParse(input, out var value))
                return Option.Some(value);
            return Option.None<int>();
        }
    }
}
