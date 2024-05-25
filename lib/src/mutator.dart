typedef Mutator<F> = F Function(F);

F maybeMutate<F>(Mutator<F>? mutator, F value) => mutator?.call(value) ?? value;
