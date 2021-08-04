/// A path constructed from [FileTree]
class FileTreePath {
  final List<String> segments;

  FileTreePath(this.segments);

  List<String> encode() => segments;

  static FileTreePath decode(List<dynamic> l) => FileTreePath(l.cast());
}
