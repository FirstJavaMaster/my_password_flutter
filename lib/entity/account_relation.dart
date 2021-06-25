import 'package:floor/floor.dart';

@entity
class AccountRelation {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int sourceId;
  final int targetId;
  String memo = '';

  AccountRelation(this.id, this.sourceId, this.targetId, this.memo);

  @override
  String toString() {
    return 'AccountRelation{id: $id, sourceId: $sourceId, targetId: $targetId, memo: $memo}';
  }
}
