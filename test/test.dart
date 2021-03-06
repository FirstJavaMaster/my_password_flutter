import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:my_password_flutter/dto/data_container.dart';

void main() {
  //
  test('test get http request', () async {
    var request = await new HttpClient().getUrl(Uri.parse('https://api.github.com/repos/FirstJavaMaster/my_password_flutter/releases/latest'));
    var response = await request.close();
    print(response.statusCode);

    var json = await response.transform(utf8.decoder).join();
    var data = jsonDecode(json);
    print(data);
  });

  test('test json read', () {
    File file = new File('F:/tmp/data_backups.json');
    var content = file.readAsStringSync();
    var decode = json.decode(content);
    var dataContainer = DataContainer.fromJson(decode);
    print(dataContainer);
  });

  test('test &', () {
    print(0xFF5151E5 & 0xFFFFFFFF);
    print(0x5151E5 & 0xFFFFFFFF);
  });

  test('test array out of bound', () {
    var array = [1, 2, 3];
    print(array[4]);
  });

  test('test pinyin', () {
    String s = '测试中文';
    String s0 = '奇偶';
    String s1 = '奇怪';
    String s2 = '0123#!@#';
    String s3 = 'english';

    print(PinyinHelper.getPinyin(s));
    print(PinyinHelper.getPinyin(s0));
    print(PinyinHelper.getPinyin(s1));
    print(PinyinHelper.getPinyin(s2));
    print(PinyinHelper.getPinyin(s3));
  });

  test('date time test', () {
    var now = DateTime.now();
    var nowString = now.toString();
    var parseTime = DateTime.parse(nowString);
    print('now: $now');
    print('nowString: $nowString');
    print('parseTime: $parseTime');
  });

  test('int == null test', () {
    print(1 == null);
  });

  test('test reg', () {
    String s = 'abcd';
    String s0 = 'Abcd';
    String s1 = '1abaf';

    print(s.startsWith(RegExp(r'[aA]')));
    print(s0.startsWith(RegExp(r'[aA]')));
    print(s1.startsWith(RegExp(r'[aA]')));
    print('-');
    print(s.startsWith(RegExp(r'[0-9]')));
    print(s0.startsWith(RegExp(r'[0-9]')));
    print(s1.startsWith(RegExp(r'[0-9]')));
  });

  test('test reg2', () {
    String s = 'abcd';
    String s0 = 'Abcd';
    String s1 = '1abaf';

    print(RegExp(r'^[aA]').hasMatch(s));
    print(RegExp(r'^[aA]').hasMatch(s0));
    print(RegExp(r'^[aA]').hasMatch(s1));
    print('-');
    print(RegExp(r'^[0-9]').hasMatch(s));
    print(RegExp(r'^[0-9]').hasMatch(s0));
    print(RegExp(r'^[0-9]').hasMatch(s1));
  });
}
