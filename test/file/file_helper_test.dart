// Import the test package and Counter class
import 'package:ltogt_utils/src/file/file_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Delete', () {
    test('Should be catchable on error', () async {
      Object? err = null;
      try {
        await FileHelper.createSubdir(dirPath: "DOES_NOT_EXIST", subDirName: "DOES_NOT_EXIST", replaceExisting: true);
      } catch (e) {
        err = e;
      }

      expect(err, isNotNull);
    });
  });
}
