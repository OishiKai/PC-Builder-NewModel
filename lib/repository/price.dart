class Price {
  Price(this._value) {
    if (_value is int) {
      _intToString(_value);
    } else if (_value is String) {
      _stringToInt(_value);
    }
  }

  final Object _value;
  int intPrice = 0;
  String stringPrice = '¥0';

  /// 1000 to "¥1,000"
  void _intToString(int intObject) {
    intPrice = intObject;
    final sValue = intObject.toString();
    final buffer = StringBuffer()..write('¥');
    for (var i = 0; i < sValue.length; i++) {
      if (i > 0 && (sValue.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(sValue[i]);
    }
    stringPrice = buffer.toString();
  }

  /// "¥1,000" to 1000
  void _stringToInt(String stringObject) {
    if (stringObject.isEmpty) {
      intPrice = 0;
      stringPrice = '¥0';
      return;
    }

    if (int.tryParse(stringObject) != null) {
      _intToString(int.parse(stringObject));
    }

    final normalizedPrice =
    stringObject.trim().replaceAll('¥', '').replaceAll(',', '');

    if (int.tryParse(normalizedPrice) != null) {
      _intToString(int.parse(normalizedPrice));
    } else {
      intPrice = 0;
      stringPrice = '¥0';
    }
  }
}
