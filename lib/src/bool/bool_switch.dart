/// Motivation:
///
/// In some cases one wants to definetly cover all combinations of multiple boolean expressions
/// § In Flutter didUpdateWidget when a controller can be passed
///   -- NewHas && OldHad
///   -- NewHas && OldHadNot
///   -- NewHasNot && OldHad
///   -- NewHasNot && OldHadNot
///
/// ```
/// bool newHasController = widget.controller != null;
/// bool oldHasController = oldWidget.controller != null;
/// BoolSwitch.two(
///   exp1: newHasController,
///   exp2: oldHasController,
///   tt: swapWidgetController,
///   tf: swapLocalForWidgetController,
///   ft: createLocalController,
///   ff: () {},
/// );
/// ```
class BoolSwitch {
  BoolSwitch._();

  static T two<T>({
    required bool exp1,
    required bool exp2,
    required T Function() tt,
    required T Function() tf,
    required T Function() ft,
    required T Function() ff,
  }) {
    if (exp1) {
      if (exp2) return tt();
      return tf();
    } else {
      if (exp2) return ft();
      return ff();
    }
  }

  static T three<T>({
    required bool exp1,
    required bool exp2,
    required bool exp3,
    required T Function() ttt,
    required T Function() ttf,
    required T Function() tft,
    required T Function() tff,
    required T Function() ftt,
    required T Function() ftf,
    required T Function() fft,
    required T Function() fff,
  }) {
    if (exp3) {
      return BoolSwitch.two(
        exp1: exp1,
        exp2: exp2,
        tt: ttt,
        tf: tft,
        ft: ftt,
        ff: fft,
      );
    }
    return BoolSwitch.two(
      exp1: exp1,
      exp2: exp2,
      tt: ttf,
      tf: tff,
      ft: ftf,
      ff: fff,
    );
  }
}
