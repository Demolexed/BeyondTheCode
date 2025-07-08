namespace Monads.Level3;
public sealed class Ok<T, E> : Result<T, E>
{
    private readonly T _value;
    public Ok(T value) { _value = value; }
    public override Result<TResult, E> Map<TResult>(System.Func<T, TResult> f) => new Ok<TResult, E>(f(_value));
    public override Result<TResult, E> Bind<TResult>(System.Func<T, Result<TResult, E>> f) => f(_value);
    public override E Error => default!;
    public T Value => _value;
}