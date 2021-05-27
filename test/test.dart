import 'package:flutter_test/flutter_test.dart';

void main() {
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
