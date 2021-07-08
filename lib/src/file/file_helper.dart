import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as pathlib;

class FileHelper {
  // ================================================= Path
  static String joinPaths(String p1, String p2) {
    return pathlib.join(p1, p2);
  }

  static String fileName(FileSystemEntity f) {
    return pathlib.basename(f.path);
  }

  // ================================================= LS
  @Deprecated("Use listDirContent instead")
  static Future<List<FileSystemEntity>> listFilesInDir(Directory dir) => listDirContent(dir);
  static Future<List<FileSystemEntity>> listDirContent(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file), onError: (e) => throw e, onDone: () => completer.complete(files));
    return completer.future;
  }

  /// Read all files from [dirPath] and order them by name alphabetically
  static Future<List<File>> listFilesInDirectoryOrdered(Directory directory) async {
    List<File> files = await listFilesInDirectory(directory);
    return files..sort((f1, f2) => f1.path.compareTo(f2.path));
  }

  /// Read all files from [dirPath]
  static Future<List<File>> listFilesInDirectory(Directory directory) {
    _validateDirExists(directory.path);

    Completer<List<File>> fileCompleter = Completer();
    List<File> files = [];

    final stream = directory.list(followLinks: false, recursive: false);
    stream.listen(
      (FileSystemEntity e) {
        if (e is File) {
          files.add(e);
        }
      },
      onDone: () => fileCompleter.complete(files),
    );

    return fileCompleter.future;
  }

  // ========================================================================= CREATE

  /// Create a subdirectory [subDirName] for the existing directory at [dirPath]
  static Future<Directory> createSubdir({
    required String dirPath,
    required String subDirName,
    required bool replaceExisting,
  }) async {
    _validateDirExists(dirPath);

    Directory subDir = Directory(joinPaths(dirPath, subDirName));
    if (await subDir.exists()) {
      if (replaceExisting) {
        await subDir.delete(recursive: true);
      } else {
        throw "Directory exists! Use replaceIfExists = true to overwrite";
      }
    }

    var dir = await subDir.create(recursive: true);
    return dir;
  }

  /// Create a file [fileName] under directory [dirPath] from [bytes]
  static Future<File> createFileFromBytes({
    required Directory directory,
    required String fileName,
    required List<int> bytes,
    required bool replaceIfExists,
  }) async {
    _validateDirExists(directory.path);

    String path = joinPaths(directory.path, fileName);
    File file = File(path);
    if (await file.exists()) {
      if (replaceIfExists) {
        file.delete();
      } else {
        throw "File exists! Use replaceIfExists = true to overwrite";
      }
    }

    return file.writeAsBytes(bytes);
  }

  // ============================================================================== Check
  /// Throw exception if directory does not exist
  static Future<void> _validateDirExists(String dirPath) async {
    if (false == await doesDirExist(dirPath)) {
      throw "Directory does not exist";
    }
  }

  /// Check if a directory exists at path
  static Future<bool> doesDirExist(String dirPath) {
    Directory dir = Directory(dirPath);
    return dir.exists();
  }
}
