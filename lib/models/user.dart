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

  User({
    int? id,
    DateTime? datetimeCreated,
    required this.name,
    required this.email,
    this.username,
    this.passwordHash,
    this.exportDir,
    this.theme,
    this.avatar,
  }) : super(id, datetimeCreated);

  User.fromSelf(Map<String, dynamic> self)
      : name = self["name"],
        email = self["email"],
        username = self["username"],
        passwordHash = self["password_hash"],
        exportDir = self["export_dir"],
        theme = self["theme"],
        avatar = self["avatar"],
        super(self["id"], DateTime.parse(self["datetime_created"]));

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
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        datetime_created TEXT NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        username TEXT,
        password_hash TEXT,
        export_dir TEXT,
        theme TEXT,
        avatar TEXT
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
      return User.fromSelf(maps[i]);
    });
  }
}
