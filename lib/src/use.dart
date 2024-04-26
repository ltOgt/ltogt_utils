extension UseX<O extends Object> on O {
  T use<T>(T Function(O self) cb) => cb(this);
}
