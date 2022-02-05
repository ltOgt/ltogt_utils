// Import the test package and Counter class
import 'dart:io';

import 'package:ltogt_utils/src/file/file_tree/file_tree.dart';
import 'package:ltogt_utils/src/file/file_tree/file_tree_helper.dart';
import 'package:ltogt_utils/src/file/file_tree/file_tree_path.dart';
import 'package:test/test.dart';

void main() {
  group('File Tree Helper', () {
    test('pathFromFileTreePathIfValid', () async {
      String path = FileTreeHelper.pathFromFileTreePathIfValid(
        fileTree: FileTree(
          rootDir: FileTreeDir(
            name: "root",
            dirs: [
              FileTreeDir(
                name: "child",
                files: [FileTreeFile(name: "file.txt")],
              ),
            ],
          ),
        ),
        rootDir: Directory("path/to/root"),
        fileTreePath: FileTreePath(["root", "child", "file.txt"]),
      );

      expect(path, equals("path/to/root/child/file.txt"));
    });
  });
}
