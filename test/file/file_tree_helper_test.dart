// Import the test package and Counter class
import 'dart:io';

import 'package:ltogt_utils/src/file/file_tree/file_tree.dart';
import 'package:ltogt_utils/src/file/file_tree/file_tree_helper.dart';
import 'package:ltogt_utils/src/file/file_tree/file_tree_path.dart';
import 'package:test/test.dart';

const tree = FileTree(
  rootDir: FileTreeDir(
    name: "root",
    dirs: [
      FileTreeDir(
        name: "child",
        files: [FileTreeFile(name: "file.txt")],
      ),
    ],
  ),
);
final root = Directory("path/to/root");

void main() {
  group('File Tree Helper', () {
    test('pathFromFileTreePathIfValid', () async {
      String path = FileTreeHelper.pathFromFileTreePathIfValid(
        fileTree: tree,
        rootDir: root,
        fileTreePath: FileTreePath(["root", "child", "file.txt"]),
      );

      expect(path, equals("path/to/root/child/file.txt"));
    });

    test('fileTreePathFromPathIfValid', () async {
      FileTreePath path = FileTreeHelper.fileTreePathFromPathIfValid(
        fileTree: tree,
        rootDir: root,
        path: "path/to/root/child/file.txt",
      );

      expect(path, equals(FileTreePath(["root", "child", "file.txt"])));
    });
  });
}
