import 'package:sqflite/sqflite.dart';

import '../../model/parts_shop.dart';
import 'database_constants.dart';
import 'database_model.dart';

class PartsShopRepository {
  PartsShopRepository._();
  static final String _tableName = PartsShopsTableField.tableName.value;
  static final String _partsId = PartsShopsTableField.partsId.value;
  static final String _rank = PartsShopsTableField.rank.value;
  static final String _price = PartsShopsTableField.price.value;
  static final String _bestPriceDiff = PartsShopsTableField.bestPriceDiff.value;
  static final String _name = PartsShopsTableField.name.value;
  static final String _pageUrl = PartsShopsTableField.pageUrl.value;

  /// 店情報保存
  /// @param shops 保存する店情報
  /// @param id 保存するPcPartsのID
  static Future<void> insertPartsShops(
      List<PartsShop>? shops, String id,) async {
    if (shops == null) {
      return;
    }
    final db = await DatabaseModel.database;
    for (final shop in shops) {
      final map = {
        _partsId: id,
        _rank: shop.rank,
        _price: shop.price,
        _bestPriceDiff: shop.bestPriceDiff,
        _name: shop.shopName,
        _pageUrl: shop.shopPageUrl,
      };
      await db.insert(
        _tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// 店情報取得
  /// @param id 取得するPcPartsのID
  /// @return 取得した店情報
  static Future<List<PartsShop>> selectPartsShopsById(String id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> mapsList = await db.query(
      _tableName,
      where: '$_partsId = ?',
      whereArgs: [id],
    );
    final shops = <PartsShop>[];
    for (final map in mapsList) {
      shops.add(
        PartsShop(
          map[_rank] as String,
          map[_price] as String,
          map[_bestPriceDiff] as String,
          map[_name] as String,
          map[_pageUrl] as String,
        ),
      );
    }
    return shops;
  }
}
