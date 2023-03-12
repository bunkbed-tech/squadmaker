import 'base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;

class User extends Base {
  static const String staticTableName = "user";
  @override
  String get tableName => staticTableName;

  String name;
  String email;
  String? username;
  String? passwordHash;
  String? exportDir;
  String? theme; // should be an AppTheme (enum)
  String? avatar;

  static const String selectStatement = """
        user.name AS user__name,
        user.email AS user__email,
        user.username AS user__username,
        user.password_hash AS user__password_hash,
        user.export_dir AS user__export_dir,
        user.theme AS user__theme,
        user.avatar AS user__avatar,
        user.datetime_created AS user__datetime_created,
        user.id as user__id
        """;

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

  User.create(Map<String, dynamic> self)
      : name = self["user__name"],
        email = self["user__email"],
        username = self["user__username"],
        passwordHash = self["user__password_hash"],
        exportDir = self["user__export_dir"],
        theme = self["user__theme"],
        avatar = self["user__avatar"],
        super(self["user__id"], DateTime.parse(self["user__datetime_created"]));

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
      CREATE TABLE $staticTableName (
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
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement
      FROM $staticTableName
      """);
    return List.generate(maps.length, (i) {
      return User.create(maps[i]);
    });
  }
}
