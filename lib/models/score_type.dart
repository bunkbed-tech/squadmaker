import 'base.dart' show Base;

class ScoreType extends Base {
  static const String _tableName = "score_type";
  @override
  String get tableName => _tableName;
  ScoreType(int? id) : super(id);

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
