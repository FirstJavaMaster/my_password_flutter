import 'package:path_provider/path_provider.dart';

class PathUtils {
  static Future<String> getExportPath() async {
    return (await getApplicationDocumentsDirectory()).path + '/export/';
  }
}
