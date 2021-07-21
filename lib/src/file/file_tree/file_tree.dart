/// ```
/// "fileTree" : {
///   "rootDir" : {
///     "name" : <dir_name>
///     "dirs" : [
///       {
///         "name" : <dir_name>,
///         "dirs" : [...],
///         "files" : [...]
///       }
///     ],
///     "files": [
///       {
///         "name" : <file_name>
///       }
///     ]
///   }
/// }
/// ```
class FileTree {
  static const String key = "fileTree";

  static const String key_rootDir = "rootDir";
  final FileTreeDir rootDir;

  FileTree({
    required this.rootDir,
  });

  Map encode() => {
        key_rootDir: this.rootDir.encode(),
      };

  static FileTree? decodeOrNull(Map m) => m == null ? null : FileTree.decode(m);
  static FileTree decode(Map m) => FileTree(
        rootDir: FileTreeDir.decode(m[key_rootDir]),
      );
}

/// ```
/// {
///   "name" : <dir_name>
///   "dirs" : [
///     {
///       "name" : <dir_name>,
///       "dirs" : [...],
///       "files" : [...]
///     }
///   ],
///   "files": [
///     {
///       "name" : <file_name>
///     }
///   ]
/// }
/// ```
class FileTreeDir {
  static const String key_name = "name";
  final String name;

  static const String key_dirs = "dirs";
  final List<FileTreeDir> dirs;

  static const String key_files = "files";
  final List<FileTreeFile> files;

  FileTreeDir({
    required this.name,
    this.dirs = const [],
    this.files = const [],
  });

  static FileTreeDir decode(Map m) => FileTreeDir(
        name: m[key_name]!,
        dirs: ((m[key_dirs] ?? []) as List<dynamic>).map((dir) => FileTreeDir.decode(dir)).toList(),
        files: ((m[key_files] ?? []) as List<dynamic>).map((file) => FileTreeFile.decode(file)).toList(),
      );

  Map encode() => {
        key_name: name,
        key_dirs: dirs.map((dir) => dir.encode()).toList(),
        key_files: files.map((file) => file.encode()).toList(),
      };
}

/// ```
/// {
///   "name" : <file_name>
/// }
/// ```
class FileTreeFile {
  static const String key_name = "name";
  final String name;

  FileTreeFile({
    required this.name,
  });

  static FileTreeFile decode(Map m) => FileTreeFile(
        name: m[key_name]!,
      );

  Map encode() => {
        key_name: name,
      };
}
