import 'base.dart' show Base;

class Payment extends Base {
  static const String _tableName = "payment";
  @override
  String get tableName => _tableName;
  Payment(int? id) : super(id);

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
