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

    test('fileTreePathFromPathIfValid', () async {
      final leafs = FileTreeHelper.getLeafsByWalking(tree);

      expect(
        leafs,
        equals([
          FileTreePath(["root", "child", "file.txt"])
        ]),
      );

      const moreComplexTree = FileTree(
        rootDir: FileTreeDir(
          name: "root",
          dirs: [
            FileTreeDir(
              name: "dir_without_file",
            ),
            FileTreeDir(
              name: "dir_with_one_file",
              files: [FileTreeFile(name: "file.txt")],
            ),
            FileTreeDir(
              name: "dir_with_two_files",
              files: [
                FileTreeFile(name: "file_1.txt"),
                FileTreeFile(name: "file_2.txt"),
              ],
            ),
            FileTreeDir(
              name: "dir_with_dir_and_file",
              dirs: [
                FileTreeDir(name: "nested_dir_empty"),
                FileTreeDir(
                  name: "nested_dir_with_file",
                  files: [
                    FileTreeFile(name: "file_1.txt"),
                  ],
                ),
              ],
              files: [
                FileTreeFile(name: "file_1.txt"),
              ],
            ),
          ],
        ),
      );

      final leafsForComplex = FileTreeHelper.getLeafsByWalking(moreComplexTree);

      expect(
        leafsForComplex,
        equals([
          FileTreePath(["root", "dir_with_one_file", "file.txt"]),
          FileTreePath(["root", "dir_with_two_files", "file_1.txt"]),
          FileTreePath(["root", "dir_with_two_files", "file_2.txt"]),
          FileTreePath(["root", "dir_with_dir_and_file", "nested_dir_with_file", "file_1.txt"]),
          FileTreePath(["root", "dir_with_dir_and_file", "file_1.txt"]),
        ]),
      );
    });
  });
}
