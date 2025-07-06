using Monads.Level3;

namespace Monads.Level3 {
    public static class SafeInverseResult {
        public static Result<double, string> SafeInverse(string input) {
            return ParseInt(input)
                .Bind(x => x == 0 ? Result<double, string>.ErrorResult("Division par zéro") : Result<double, string>.Ok(1.0 / x));
        }

        private static Result<int, string> ParseInt(string input) {
            if (int.TryParse(input, out var value))
                return Result<int, string>.Ok(value);
            return Result<int, string>.ErrorResult($"'{input}' n'est pas un entier valide");
        }
    }
}
