namespace Monads.Level3;

public sealed class ErrorResult<T, E> : Result<T, E>
{
    private readonly E _error;
    public ErrorResult(E error) { _error = error; }
    public override Result<TResult, E> Map<TResult>(System.Func<T, TResult> f) => new ErrorResult<TResult, E>(_error);
    public override Result<TResult, E> Bind<TResult>(System.Func<T, Result<TResult, E>> f) => new ErrorResult<TResult, E>(_error);
    public override E Error => _error;
}