namespace Monads.Level1 
{
    /// <summary>
    /// Abstract base class for Option monad
    /// </summary>
    public abstract class Option<T> 
    {
        /// <summary>
        /// Transform the value if present
        /// </summary>
        public abstract Option<TResult> Map<TResult>(Func<T, TResult> transform);
        
        /// <summary>
        /// Chain operations that also return Option
        /// </summary>
        public abstract Option<TResult> Bind<TResult>(Func<T, Option<TResult>> transform);
        
        /// <summary>
        /// Check if value is present
        /// </summary>
        public abstract bool HasValue { get; }
        
        /// <summary>
        /// Get the value (throws if None)
        /// </summary>
        public abstract T Value { get; }
    }
}
