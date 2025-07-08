namespace Monads.Level3;

public abstract class Result<T, E>
{
    public abstract Result<TResult, E> Map<TResult>(System.Func<T, TResult> f);
    public abstract Result<TResult, E> Bind<TResult>(System.Func<T, Result<TResult, E>> f);
    public abstract E Error { get; }
    public static Result<T, E> Ok(T value) => new Ok<T, E>(value);
    public static Result<T, E> ErrorResult(E error) => new ErrorResult<T, E>(error);
}