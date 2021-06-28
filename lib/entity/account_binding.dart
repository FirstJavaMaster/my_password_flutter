import 'package:floor/floor.dart';

@entity
class AccountBinding {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int sourceId;
  final int targetId;
  String memo = '';

  AccountBinding(this.id, this.sourceId, this.targetId, this.memo);

  AccountBinding.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sourceId = json['sourceId'],
        targetId = json['targetId'],
        memo = json['memo'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceId': sourceId,
        'targetId': targetId,
        'memo': memo,
      };

  @override
  String toString() {
    return 'AccountBinding{id: $id, sourceId: $sourceId, targetId: $targetId, memo: $memo}';
  }
}
