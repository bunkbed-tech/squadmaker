import 'package:models/enums.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String passwordHash;
  final String exportDir;
  final AppTheme theme;
  final String avatar;
  final DateTime datetimeCreated;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.passwordHash,
    required this.exportDir,
    required this.theme,
    this.avatar,
    required this.datetimeCreated,
  });

  String createSQLTable() {
    return """
      CREATE TABLE user (
        id SERIAL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        username TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        export_dir TEXT NOT NULL,
        theme INTEGER NOT NULL REFERENCES app_theme (id),
        avatar TEXT,
        datetime_created TEXT NOT NULL,
      );
    """;    
  }
}
