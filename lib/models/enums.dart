enum Gender {
  man,
  woman,
  other;

  static String createSQLTable() {
    return """
      CREATE TABLE gender (id SERIAL, name TEXT UNIQUE);
    """;
  }
}

enum Sport {
  kickball,
  baseball,
  softball
}

enum AppTheme {
  light,
  dark
}
