/// Splits a stream of consecutive messages based on a [delimiter].
///
/// The messages are provided through [source], where any single message may be
/// split into multiple chunks, i.e. may not be transmitted wholly in one chunk.
///
/// Based on the example in https://dart.dev/articles/libraries/creating-streams
Stream<String> splitStream(Stream<String> source, Pattern delimiter) async* {
  // Stores last message from the previous chunk as it may be a partial message.
  String partial = "";

  // Wait until a new chunk is available, then process it.
  await for (final chunk in source) {
    final messages = chunk.split(delimiter);

    // Prepend previous last message.
    // if it was partial, messages[0] is not empty, otherwise it is.
    messages[0] = partial + messages[0];

    // Buffer the last message of the chunk, as it may incomplete
    partial = messages.removeLast();
    for (final msg in messages) {
      yield msg;
    }
  }
  // Add final partial line to output stream, if any.
  if (partial.isNotEmpty) yield partial;
}
