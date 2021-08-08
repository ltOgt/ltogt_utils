import 'package:ltogt_utils/src/file/file_tree/file_tree.dart';

/// A path constructed from [FileTree]
class FileTreePath {
  final List<String> segments;

  FileTreePath(this.segments);

  void addSegment(FileTreeEntity e) => this.segments.add(e.name);

  List<String> encode() => segments;

  static FileTreePath decode(List<dynamic> l) => FileTreePath(l.cast());
}
