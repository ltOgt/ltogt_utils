/// A path constructed from [FileTree]
class FileTreePath {
  final List<String> path;

  FileTreePath(this.path);

  List<String> encode() => path;

  static FileTreePath decode(List<dynamic> l) => FileTreePath(l.cast());
}
