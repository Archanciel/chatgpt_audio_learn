class UiUtil {
  static String formatLargeIntValue(int value) {
    String formattedValueStr;

    if (value < 1000000) {
      formattedValueStr = '${value ~/ 1000} Ko';
    } else {
      formattedValueStr = '${(value / 1000000).toStringAsFixed(2)} Mo';
    }
    return formattedValueStr;
  }
}