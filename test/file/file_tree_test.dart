import 'package:ltogt_utils/src/file/file_tree/file_tree_path.dart';
import 'package:test/test.dart';

void main() {
  group('File Path', () {
    test('equal file paths are equal', () async {
      final p1 = FileTreePath(["this", "is", "my", "path.txt"]);
      final p2 = FileTreePath(["this", "is", "my", "path.txt"]);

      expect(p1 == p2, isTrue);
      expect(p1.hashCode == p2.hashCode, isTrue);
    });

    test('file paths can be used as keys in maps', () async {
      final p1 = FileTreePath(["this", "is", "my", "path1.txt"]);
      final p2 = FileTreePath(["this", "is", "my", "path2.txt"]);
      final pNot = FileTreePath(["this", "is", "my", "pathNot.txt"]);

      Map<FileTreePath, int> m = {
        p1: 1,
        p2: 2,
      };

      expect(m.containsKey(p1), isTrue);
      expect(m.containsKey(p2), isTrue);
      expect(m.containsKey(pNot), isFalse);

      expect(m[p1], equals(1));
      expect(m[p2], equals(2));
      expect(m[pNot], isNull);

      final p1Star = FileTreePath(["this", "is", "my", "path1.txt"]);
      expect(m.containsKey(p1Star), isTrue);
      expect(m[p1Star], equals(1));
    });

    test('asFilePathWithSystemRoot can handle trailing slash', () async {
      final p1 = FileTreePath(["root", "and", "sub", "path.txt"]);

      expect(p1.asFilePathWithSystemRoot("/system/to/root"), "/system/to/root/and/sub/path.txt");
      expect(p1.asFilePathWithSystemRoot("/system/to/root/"), "/system/to/root/and/sub/path.txt");
    });
  });
}
