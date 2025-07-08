using Monads.Level1;

namespace Monads.Level2 {
    public static class OptionChaining {
        public static Option<double> SafeInverse(string input) {
            return ParseInt(input)
                .Bind(x => x == 0 ? Option.None<double>() : Option.Some(1.0 / x));
        }

        private static Option<int> ParseInt(string input) {
            if (int.TryParse(input, out var value))
                return Option.Some(value);
            return Option.None<int>();
        }
    }
}
