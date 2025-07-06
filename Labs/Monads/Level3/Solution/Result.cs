namespace Monads.Level3 {
    public abstract class Result<T, E> {
        public abstract Result<TResult, E> Map<TResult>(System.Func<T, TResult> f);
        public abstract Result<TResult, E> Bind<TResult>(System.Func<T, Result<TResult, E>> f);
        public abstract E Error { get; }
        public static Result<T, E> Ok(T value) => new Ok<T, E>(value);
        public static Result<T, E> ErrorResult(E error) => new ErrorResult<T, E>(error);
    }

    public sealed class Ok<T, E> : Result<T, E> {
        private readonly T _value;
        public Ok(T value) { _value = value; }
        public override Result<TResult, E> Map<TResult>(System.Func<T, TResult> f) => new Ok<TResult, E>(f(_value));
        public override Result<TResult, E> Bind<TResult>(System.Func<T, Result<TResult, E>> f) => f(_value);
        public override E Error => default!;
        public T Value => _value;
    }

public sealed class ErrorResult<T, E> : Result<T, E> {
    private readonly E _error;
    public ErrorResult(E error) { _error = error; }
    public override Result<TResult, E> Map<TResult>(System.Func<T, TResult> f) => new ErrorResult<TResult, E>(_error);
    public override Result<TResult, E> Bind<TResult>(System.Func<T, Result<TResult, E>> f) => new ErrorResult<TResult, E>(_error);
    public override E Error => _error;
}
}
