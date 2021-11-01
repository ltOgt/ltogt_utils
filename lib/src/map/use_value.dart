/// Shorthand for (value){return doSomethingWith(value)}(someConstructionOfValue())
///
/// E.g.: `useValue(MyComplicatedConstructor(a,b,c,d,e), (v) => v.x + v.y)`
/// instead of `(MyComplicatedConstructor v) {return v.x + v.y;} (MyComplicatedConstructor(a,b,c,d,e))`
R useValue<T, R>(T value, R Function(T value) use) => use(value);
