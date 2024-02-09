class Price {
  Price(this.value) {
    if (value is int) {
      intPrice = value as int;
      stringPrice = intToString();
    } else if (value is String) {
      stringPrice = value as String;
      intPrice = stringToInt();
    }
  }

  final Object value;
  int intPrice = 0;
  String stringPrice = '¥0';

  /// 1000 to "¥1,000"
  String intToString() {
    final sValue = intPrice.toString();
    final buffer = StringBuffer()..write('¥');
    for (var i = 0; i < sValue.length; i++) {
      if (i > 0 && (sValue.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(sValue[i]);
    }
    return buffer.toString();
  }

  /// "¥1,000" to 1000
  int stringToInt() {
    final normalizedPrice =
        stringPrice.trim().replaceAll('¥', '').replaceAll(',', '');
    return normalizedPrice.isEmpty ? 0 : int.parse(normalizedPrice);
  }
}
