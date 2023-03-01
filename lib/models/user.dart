import 'base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;

class User extends Base {
  static const String _tableName = "user";
  @override
  String get tableName => _tableName;

  String name;
  String email;
  String? username;
  String? passwordHash;
  String? exportDir;
  String? theme; // should be an AppTheme (enum)
  String? avatar;
  String? datetimeCreated; // should be a DateTime

  User({
    int? id,
    required this.name,
    required this.email,
    this.username,
    this.passwordHash,
    this.exportDir,
    this.theme,
    this.avatar,
    this.datetimeCreated,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "username": username,
      "password_hash": passwordHash,
      "export_dir": exportDir,
      "theme": theme,
      "avatar": avatar,
      "datetime_created": datetimeCreated,
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        username TEXT,
        password_hash TEXT,
        export_dir TEXT,
        theme TEXT,
        avatar TEXT,
        datetime_created TEXT
      );
    """;
  }

  @override
  String toString() {
    return "User{id: $id, name: $name, email: $email}";
  }

  static Future<List<User>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]["id"],
        name: maps[i]["name"],
        email: maps[i]["email"],
        username: maps[i]["username"],
        passwordHash: maps[i]["password_hash"],
        exportDir: maps[i]["export_dir"],
        theme: maps[i]["theme"],
        avatar: maps[i]["avatar"],
        datetimeCreated: maps[i]["datetime_created"],
      );
    });
  }
}
