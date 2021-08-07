import 'package:collection/collection.dart';

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
///     ],
///     "lastChange": ?<last_change>,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileTree && other.rootDir == rootDir;
  }

  @override
  int get hashCode => rootDir.hashCode;
}

abstract class FileTreeEntity {
  String get name;
  bool get isDir => this is FileTreeDir;
  bool get isFile => this is FileTreeFile;
  DateTime? get lastChange;
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
class FileTreeDir extends FileTreeEntity {
  static const String key_name = "name";
  final String name;

  static const key_lastChange = "lc";
  final DateTime? lastChange;

  List<FileTreeEntity> get entities => List.from(dirs)..addAll(files);

  static const String key_dirs = "dirs";
  final List<FileTreeDir> dirs;

  static const String key_files = "files";
  final List<FileTreeFile> files;

  FileTreeDir({
    required this.name,
    this.dirs = const [],
    this.files = const [],
    this.lastChange,
  });

  static FileTreeDir decode(Map m) => FileTreeDir(
        name: m[key_name]!,
        dirs: ((m[key_dirs] ?? []) as List<dynamic>).map((dir) => FileTreeDir.decode(dir)).toList(),
        files: ((m[key_files] ?? []) as List<dynamic>).map((file) => FileTreeFile.decode(file)).toList(),
        lastChange: m[key_lastChange] == null ? null : DateTime.fromMillisecondsSinceEpoch(m[key_lastChange]),
      );

  Map encode() => {
        key_name: name,
        key_dirs: dirs.map((dir) => dir.encode()).toList(),
        key_files: files.map((file) => file.encode()).toList(),
        if (lastChange != null) key_lastChange: lastChange!.millisecondsSinceEpoch,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is FileTreeDir &&
        other.name == name &&
        other.lastChange == lastChange &&
        listEquals(other.dirs, dirs) &&
        listEquals(other.files, files);
  }

  @override
  int get hashCode {
    return name.hashCode ^ lastChange.hashCode ^ dirs.hashCode ^ files.hashCode;
  }
}

/// ```
/// {
///   "name" : <file_name>
/// }
/// ```
class FileTreeFile extends FileTreeEntity {
  static const String key_name = "name";
  final String name;

  static const key_lastChange = "lc";
  final DateTime? lastChange;

  FileTreeFile({
    required this.name,
    this.lastChange,
  });

  static FileTreeFile decode(Map m) => FileTreeFile(
        name: m[key_name]!,
        lastChange: m[key_lastChange] == null ? null : DateTime.fromMillisecondsSinceEpoch(m[key_lastChange]),
      );

  Map encode() => {
        key_name: name,
        if (lastChange != null) key_lastChange: lastChange!.millisecondsSinceEpoch,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileTreeFile && other.name == name && other.lastChange == lastChange;
  }

  @override
  int get hashCode => name.hashCode ^ lastChange.hashCode;
}
