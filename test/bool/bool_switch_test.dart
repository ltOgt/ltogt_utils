// Import the test package and Counter class
import 'package:ltogt_utils/src/bool/bool_switch.dart';
import 'package:test/test.dart';

void main() {
  group('bool switch', () {
    test('two - should cover all cases', () async {
      const cases = [
        [false, false, "ff"],
        [false, true, "ft"],
        [true, false, "tf"],
        [true, true, "tt"],
      ];

      for (List c in cases) {
        String? result;
        BoolSwitch.two(
          exp1: c[0],
          exp2: c[1],
          ff: () => result = "ff",
          ft: () => result = "ft",
          tf: () => result = "tf",
          tt: () => result = "tt",
        );
        expect(result, equals(c[2]));
      }
    });

    test('three - should cover all cases', () async {
      const cases = [
        [false, false, false, "fff"],
        [false, false, true, "fft"],
        [false, true, false, "ftf"],
        [false, true, true, "ftt"],
        [true, false, false, "tff"],
        [true, false, true, "tft"],
        [true, true, false, "ttf"],
        [true, true, true, "ttt"],
      ];

      for (List c in cases) {
        String? result;
        BoolSwitch.three(
          exp1: c[0],
          exp2: c[1],
          exp3: c[2],
          fff: () => result = "fff",
          fft: () => result = "fft",
          ftf: () => result = "ftf",
          ftt: () => result = "ftt",
          tff: () => result = "tff",
          tft: () => result = "tft",
          ttf: () => result = "ttf",
          ttt: () => result = "ttt",
        );
        expect(result, equals(c[3]));
      }
    });
  });
}
