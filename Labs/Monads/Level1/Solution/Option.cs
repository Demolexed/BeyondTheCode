namespace Monads.Level1 {
    public abstract class Option<T> {
        public abstract Option<TResult> Map<TResult>(System.Func<T, TResult> f);
        public abstract Option<TResult> Bind<TResult>(System.Func<T, Option<TResult>> f);
        public static Option<T> Some(T value) => new Some<T>(value);
        public static Option<T> None() => new None<T>();
    }

    public sealed class Some<T> : Option<T> {
        private readonly T _value;
        public Some(T value) { _value = value; }
        public override Option<TResult> Map<TResult>(System.Func<T, TResult> f) => new Some<TResult>(f(_value));
        public override Option<TResult> Bind<TResult>(System.Func<T, Option<TResult>> f) => f(_value);
        public T Value => _value;
    }

    public sealed class None<T> : Option<T> {
        public override Option<TResult> Map<TResult>(System.Func<T, TResult> f) => new None<TResult>();
        public override Option<TResult> Bind<TResult>(System.Func<T, Option<TResult>> f) => new None<TResult>();
    }
}
