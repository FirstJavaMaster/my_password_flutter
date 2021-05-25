
void main() {
  var now = DateTime.now();
  var nowString = now.toString();
  var parseTime = DateTime.parse(nowString);
  print('now: $now');
  print('nowString: $nowString');
  print('parseTime: $parseTime');
}
