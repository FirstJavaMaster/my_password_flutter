import 'dart:convert';

import 'package:my_password_flutter/entity/account.dart';

class JsonUtils {
  static List<Account> jsonToAccountList(String content) {
    List list = json.decode(content);
    return list.map((e) => Account.fromJson(e)).toList();
  }

  static String accountListToJson(List<Account> accountList) {
    var jsonEncoder = JsonEncoder.withIndent('  ');
    return jsonEncoder.convert(accountList);
  }
}
