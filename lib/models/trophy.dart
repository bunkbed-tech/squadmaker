import 'base.dart' show Base;

class Trophy extends Base {
  static const String _tableName = "trophy";
  @override
  String get tableName => _tableName;
  Trophy(int? id) : super(id);

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
