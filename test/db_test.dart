import 'package:custom_pc_new_model/model/custom.dart';
import 'package:custom_pc_new_model/model/parts_category.dart';
import 'package:custom_pc_new_model/model/parts_shop.dart';
import 'package:custom_pc_new_model/model/pc_parts.dart';
import 'package:custom_pc_new_model/repository/db/custom_repository.dart';
import 'package:test/test.dart';

void main() {

  final aParts = PcParts(
    category: PartsCategory.graphicsCard,
    id: 'K0001601183',
    maker: '玄人志向',
    isNew: false,
    title: 'GALAKURO GAMING GG-RTX4070TiSP-E16GB/EX/TP [PCIExp 16GB]',
    star: 4,
    evaluation: '4.0',
    price: '¥139,980',
    ranked: '1',
    image: 'https://img1.kakaku.k-img.com/images/productimage/fullscale/K0001601183.jpg',
    detailUrl: 'https://kakaku.com/item/K0001601183/',
    fullScaleImages: [
      'https://img1.kakaku.k-img.com/images/productimage/fullscale/K0001601183.jpg',
      'https://img1.kakaku.k-img.com/images/productimage/fullscale/K0001601183.jpg',
      'https://img1.kakaku.k-img.com/images/productimage/fullscale/K0001601183.jpg',
    ],
    specs: {
      'GPU': 'NVIDIA GeForce RTX 4070 Ti',
      'メモリ': '16GB',
      'コアクロック': '1,800MHz',
      'メモリクロック': '19,000MHz',
      'バスインターフェース': 'PCI-Express4.0x16',
      '出力端子': 'HDMIx1/DisplayPortx3',
      '補助電源コネクタ': '8+8ピンx2',
      '長さ': '320mm',
      'スロット数': '2',
      '製品保証': '3年',
    },
    shops: [
      PartsShop('1','139980', '0', '玄人志向','https://kakaku.com/item/K0001601183/',),
      PartsShop('2','139980', '0', '玄人志向','https://kakaku.com/item/K0001601183/',),
      PartsShop('3','139980', '0', '玄人志向','https://kakaku.com/item/K0001601183/',),
    ],
  );


  group('CustomRepository', () {
    test('insertCustom', () async {
      final custom = Custom(
        id: 'id',
        name: 'name',
        totalPrice: '1000',
        parts: [aParts],
        date: '2021/1/1',
        compatibilities: [],
      );
      await CustomRepository.insertCustom(custom);
    });
  });
}
