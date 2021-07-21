import 'dart:io';

import 'package:ltogt_utils/ltogt_utils.dart';

import 'file_tree.dart';
import 'file_tree_path.dart';

class FileTreeHelper {
  /// Recursively builds a [FileTree] starting from [rootDir], ignoring [blacklist] and stopping at [maxDepth] (default `30`).
  ///
  /// Ignores Links for now.
  ///
  // TODO implement symlink check, for now just ignored
  // Does not follow symlinks unless [followSymlinks] is explicitly set to true.
  // If true, still does not follow links that leave [rootDir]
  ///
  /// {@template createFileTree_validity}
  ///
  /// Gurantees that all files in the tree
  /// - do not leave [rootDir]
  /// - point to an existing file / directory
  /// {@endtemplate}
  static Future<FileTree> createFileTree({
    required Directory rootDir,
    List<String> blacklist = const [],
    int maxDepth = 30,
    bool followSymlinks = false,
  }) async {
    return FileTree(rootDir: await _walkDirRecursion(rootDir, maxDepth));
  }

  static Future<FileTreeDir> _walkDirRecursion(Directory directory, int recursions) async {
    String name = FileHelper.fileName(directory);
    List<FileTreeFile> files = [];
    List<FileTreeDir> dirs = [];

    List<FileSystemEntity> dirContent = await FileHelper.listDirContent(directory);
    // TODO need to check against symbolic links
    for (FileSystemEntity entity in dirContent) {
      if (entity is Directory) {
        dirs.add(await _walkDirRecursion(entity, recursions - 1));
      } else if (entity is File) {
        files.add(FileTreeFile(name: FileHelper.fileName(entity)));
      }
    }

    return FileTreeDir(
      name: name,
      files: files,
      dirs: dirs,
    );
  }

  /// Use [fileTree] (created via [createFileTree]) to validate [fileTreePath].
  ///
  /// [fileTreePath] is valid in accordance to the construction performed by [createFileDir]:
  /// {@macro createFileTree_validity}
  ///
  ///
  /// If [fileTreePath] is valid, an actual path is returned pointing to the file on disk.
  /// Otherwise an Exception is thrown.
  static String pathFromFileTreePathIfValid({
    required FileTree fileTree,
    required Directory rootDir,
    required FileTreePath fileTreePath,
  }) {
    List<String> pathSegments = fileTreePath.path;
    try {
      if (fileTree.rootDir.name != pathSegments.first) {
        throw Exception("Does not start at [rootDir]");
      }

      FileTreeDir currentDir = fileTree.rootDir;
      for (int i = 1; i < pathSegments.length - 1; i++) {
        // Throws StateError if no directory matching the path segment is found
        currentDir = currentDir.dirs.firstWhere((dir) => dir.name == pathSegments[i]);
      }
      // The last segment must be the name of the requested file
      // Throws StateError if no file matching the segment is found
      currentDir.files.firstWhere((file) => file.name == pathSegments.last);
    } catch (e) {
      throw Exception("Invalid [fileTreePath]: $e");
    }

    // Path segments are valid and can be joined to create a file path
    return pathSegments.fold(rootDir.path, (acc, ele) => FileHelper.joinPaths(acc, ele));
  }
}
