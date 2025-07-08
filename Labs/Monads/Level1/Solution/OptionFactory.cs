namespace Monads.Level1 
{
    /// <summary>
    /// Static factory methods for creating Option instances
    /// </summary>
    public static class Option 
    {
        /// <summary>
        /// Create an Option with a value
        /// </summary>
        public static Option<T> Some<T>(T value) => new Some<T>(value);
        
        /// <summary>
        /// Create an Option with no value
        /// </summary>
        public static Option<T> None<T>() => new None<T>();

        /// <summary>
        /// Convert a nullable reference to an Option
        /// </summary>
        public static Option<T> FromNullable<T>(T? value) where T : class
        {
            return value != null ? Some(value) : None<T>();
        }
    }
}
