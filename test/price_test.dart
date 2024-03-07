import 'package:custom_pc_new_model/repository/price.dart';
import 'package:test/test.dart';

void main() {
  test('price from string test', () {
    final price = Price('¥1,000');
    expect(price.intPrice, 1000);
    expect(price.stringPrice, '¥1,000');

    final price2 = Price('¥1000');
    expect(price2.intPrice, 1000);
    expect(price2.stringPrice, '¥1,000');

    final price3 = Price('¥0');
    expect(price3.intPrice, 0);
    expect(price3.stringPrice, '¥0');

    final price4 = Price('¥');
    expect(price4.intPrice, 0);
    expect(price4.stringPrice, '¥0');

    final price5 = Price('1000');
    expect(price5.intPrice, 1000);
    expect(price5.stringPrice, '¥1,000');

    final price6 = Price('1,000');
    expect(price6.intPrice, 1000);
    expect(price6.stringPrice, '¥1,000');

    final price7 = Price('');
    expect(price7.intPrice, 0);
    expect(price7.stringPrice, '¥0');

    final price8 = Price('a');
    expect(price8.intPrice, 0);
    expect(price8.stringPrice, '¥0');

    final price9 = Price('1a2b');
    expect(price9.intPrice, 0);
    expect(price9.stringPrice, '¥0');

    final price10 = Price('¥1,000 ');
    expect(price10.intPrice, 1000);
    expect(price10.stringPrice, '¥1,000');

    final price11 = Price(' ¥1,000');
    expect(price11.intPrice, 1000);
    expect(price11.stringPrice, '¥1,000');

    final price12 = Price('¥1,000　');
    expect(price12.intPrice, 1000);
    expect(price12.stringPrice, '¥1,000');
  });

  test('price from int test', () {
    final price3 = Price(100);
    expect(price3.intPrice, 100);
    expect(price3.stringPrice, '¥100');

    final price = Price(1000);
    expect(price.intPrice, 1000);
    expect(price.stringPrice, '¥1,000');

    final price2 = Price(0);
    expect(price2.intPrice, 0);
    expect(price2.stringPrice, '¥0');
  });
}
