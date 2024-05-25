typedef Mutator<F> = F Function(F old);

F maybeMutate<F>(Mutator<F>? mutator, F value) => mutator == null ? value : mutator.call(value);
