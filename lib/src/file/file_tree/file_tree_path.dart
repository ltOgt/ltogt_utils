// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

import 'package:ltogt_utils/src/file/file_tree/file_tree.dart';

/// A path constructed from [FileTree]
class FileTreePath {
  final List<String> segments;

  FileTreePath(this.segments);

  void addSegment(FileTreeEntity e) => this.segments.add(e.name);

  List<String> get segmentsWithoutRoot => segments.length < 2 ? const [] : segments.sublist(1);

  List<String> encode() => segments;

  static FileTreePath decode(List<dynamic> l) => FileTreePath(l.cast());

  @override
  String toString() {
    return "[${segments.join(',')}]";
  }

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
