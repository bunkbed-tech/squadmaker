import 'base.dart' show Base;

class Score extends Base {
  static const String _tableName = "score";
  @override
  String get tableName => _tableName;
  Score(int? id) : super(id);

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
