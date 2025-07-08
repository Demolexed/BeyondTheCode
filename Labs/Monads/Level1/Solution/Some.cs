namespace Monads.Level1 
{
    /// <summary>
    /// Represents an Option that contains a value
    /// </summary>
    public class Some<T> : Option<T> 
    {
        private readonly T _value;
        
        public Some(T value) 
        {
            _value = value;
        }
        
        public override bool HasValue => true;
        public override T Value => _value;
        
        public override Option<TResult> Map<TResult>(Func<T, TResult> transform)
        {
            return new Some<TResult>(transform(_value));
        }
        
        public override Option<TResult> Bind<TResult>(Func<T, Option<TResult>> transform)
        {
            return transform(_value);
        }
    }
}
