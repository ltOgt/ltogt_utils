// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

import 'package:ltogt_utils/src/file/file_tree/file_tree.dart';

/// A path constructed from [FileTree].
///
/// The root folder is included, but the system path to that root folder is hidden.
class FileTreePath {
  /// Segments of the tree path, starting with the root folder.
  ///
  /// The system path to the root is not included, and explicitly hidden.
  ///
  /// See [segmentsWithoutRoot] and [asFilePathWithSystemRoot].
  final List<String> segments;

  const FileTreePath(this.segments);

  void addSegment(FileTreeEntity e) => this.segments.add(e.name);

  List<String> get segmentsWithoutRoot => segments.length < 2 ? const [] : segments.sublist(1);

  List<String> encode() => segments;

  static FileTreePath decode(List<dynamic> l) => FileTreePath(l.cast());

  @override
  String toString() {
    return "[${segments.join(',')}]";
  }

  /// Joins the tree path segments with `/`
  String asFilePath() => segments.join('/');

  /// Joins the [systemRootPath] with [segmentsWithoutRoot]
  /// which produces the full system path to the file.
  String asFilePathWithSystemRoot(String systemRootPath) =>
      systemRootPath + (systemRootPath.endsWith('/') ? '' : "/") + segmentsWithoutRoot.join('/');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is FileTreePath && listEquals(other.segments, segments);
  }

  @override
  int get hashCode {
    final listHash = const DeepCollectionEquality().hash;
    return listHash(segments);
  }
}
