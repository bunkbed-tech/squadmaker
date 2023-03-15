import 'package:squadmaker/models/base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;

class User extends Base {
  static const String staticTableName = "user";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  String name;
  String email;
  String? username;
  String? passwordHash;
  String? exportDir;
  String? theme; // should be an AppTheme (enum)
  String? avatar;

  static String selectStatement = """
        ${staticTableName}.name AS ${prefix}name,
        ${staticTableName}.email AS ${prefix}email,
        ${staticTableName}.username AS ${prefix}username,
        ${staticTableName}.password_hash AS ${prefix}password_hash,
        ${staticTableName}.export_dir AS ${prefix}export_dir,
        ${staticTableName}.theme AS ${prefix}theme,
        ${staticTableName}.avatar AS ${prefix}avatar,
        ${staticTableName}.datetime_created AS ${prefix}datetime_created,
        ${staticTableName}.id as ${prefix}id
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
      : name = self["${prefix}name"],
        email = self["${prefix}email"],
        username = self["${prefix}username"],
        passwordHash = self["${prefix}password_hash"],
        exportDir = self["${prefix}export_dir"],
        theme = self["${prefix}theme"],
        avatar = self["${prefix}avatar"],
        super(self["${prefix}id"],
            DateTime.parse(self["${prefix}datetime_created"]));

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
