// lib/core/db/web_stub.dart
//
// Web stub that satisfies conditional imports for packages that don't
// support web (sqflite, path). When the conditional import resolves to
// this file on web, nothing is exported — the kIsWeb guards in
// database_helper.dart prevent any actual usage.

// ignore_for_file: unused_element

// Minimal stubs so the Dart analyser is happy on the web target.
// None of these are ever called at runtime because every DatabaseHelper
// method returns early when kIsWeb == true.

/// Stub for sqflite's [Database] type.
abstract class Database {}

/// Stub for sqflite's [ConflictAlgorithm].
class ConflictAlgorithm {
  static const ConflictAlgorithm replace = ConflictAlgorithm._();
  const ConflictAlgorithm._();
}

/// Stub for sqflite's top-level helpers.
class Sqflite {
  static int? firstIntValue(List<Map<String, Object?>> list) => null;
}

/// Stub for sqflite's [openDatabase].
Future<Database> openDatabase(
  String path, {
  int? version,
  dynamic onCreate,
  dynamic onUpgrade,
}) async {
  throw UnsupportedError('sqflite is not supported on web');
}

/// Stub for sqflite's [getDatabasesPath].
Future<String> getDatabasesPath() async {
  throw UnsupportedError('sqflite is not supported on web');
}

/// Stub for path's [join].
String join(String part1, [String? part2, String? part3]) {
  throw UnsupportedError('path join is not supported on web');
}
