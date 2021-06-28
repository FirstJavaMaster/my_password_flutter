import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/account_binding.dart';
import 'package:my_password_flutter/entity/old_password.dart';

class DataContainer {
  List<Account> accountList;
  List<AccountBinding> accountBindingList;
  List<OldPassword> oldPasswordList;

  DataContainer(this.accountList, this.accountBindingList, this.oldPasswordList);

  DataContainer.fromJson(Map<String, dynamic> json)
      : accountList = (json['accountList'] as List<dynamic>).map((e) => Account.fromJson(e as Map<String, dynamic>)).toList(),
        accountBindingList = (json['accountBindingList'] as List<dynamic>).map((e) => AccountBinding.fromJson(e as Map<String, dynamic>)).toList(),
        oldPasswordList = (json['oldPasswordList'] as List<dynamic>).map((e) => OldPassword.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
        'accountList': accountList,
        'accountBindingList': accountBindingList,
        'oldPasswordList': oldPasswordList,
      };

  @override
  String toString() {
    return 'DataContainer{accountList: $accountList, accountBindingList: $accountBindingList, oldPasswordList: $oldPasswordList}';
  }
}
