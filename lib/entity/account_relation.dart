import 'package:floor/floor.dart';

@entity
class AccountRelation {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int source_id;
  final int target_id;
  String memo = '';

  AccountRelation(this.id, this.source_id, this.target_id, this.memo);

  @override
  String toString() {
    return 'AccountRelation{id: $id, source_id: $source_id, target_id: $target_id, memo: $memo}';
  }
}
