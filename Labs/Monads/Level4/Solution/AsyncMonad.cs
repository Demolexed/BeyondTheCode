using System;
using System.Threading.Tasks;

namespace Monads.Level4 {
    public class Async<T> {
        private readonly Task<T> _task;
        public Async(Task<T> task) { _task = task; }
        public Task<T> Task => _task;
        public Async<TResult> Map<TResult>(Func<T, TResult> f) => new Async<TResult>(_task.ContinueWith(t => f(t.Result)));
        public Async<TResult> Bind<TResult>(Func<T, Async<TResult>> f)
            => new Async<TResult>(_task.ContinueWith(t => f(t.Result)._task).Unwrap());
        public static Async<T> FromResult(T value) => new Async<T>(System.Threading.Tasks.Task.FromResult(value));
    }
}
