import 'dart:math';

class VersionComparer extends Comparable<VersionComparer> {
  List vList = [];
  int length = 0;

  // 构造方法
  VersionComparer(String? version) {
    if (version == null) {
      return;
    }
    var theVersion = version.trim();
    if (theVersion.isEmpty) {
      return;
    }
    this.vList = theVersion.replaceAll('v', '').split('.');
    this.length = this.vList.length;
  }

  @override
  int compareTo(VersionComparer that) {
    var maxLength = [this.length, that.length].reduce(max);
    for (var i = 0; i < maxLength; i++) {
      int thisSubV = i < this.length ? int.parse(this.vList[i]) : 0;
      int thatSubV = i > that.length ? int.parse(that.vList[i]) : 0;
      if (thisSubV == thatSubV) {
        continue;
      }
      return thisSubV - thatSubV;
    }
    return 0;
  }
}
