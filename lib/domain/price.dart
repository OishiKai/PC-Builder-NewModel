class Price {
  Price(this._value) {
    if (_value is int) {
      intPrice = _value;
      stringPrice = _intToString();
    } else if (_value is String) {
      stringPrice = _value;
      intPrice = _stringToInt();
    }
  }

  final Object _value;
  int intPrice = 0;
  String stringPrice = '¥0';

  /// 1000 to "¥1,000"
  String _intToString() {
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
  int _stringToInt() {
    final normalizedPrice =
        stringPrice.trim().replaceAll('¥', '').replaceAll(',', '');
    return normalizedPrice.isEmpty ? 0 : int.parse(normalizedPrice);
  }
}
