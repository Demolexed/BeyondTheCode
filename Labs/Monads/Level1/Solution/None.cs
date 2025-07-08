namespace Monads.Level1 
{
    /// <summary>
    /// Represents an Option that contains no value
    /// </summary>
    public class None<T> : Option<T> 
    {
        public override bool HasValue => false;
        public override T Value => throw new InvalidOperationException("No value present");
        
        public override Option<TResult> Map<TResult>(Func<T, TResult> transform)
        {
            return new None<TResult>();
        }
        
        public override Option<TResult> Bind<TResult>(Func<T, Option<TResult>> transform)
        {
            return new None<TResult>();
        }
    }
}
