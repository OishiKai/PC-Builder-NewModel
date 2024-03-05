import 'package:custom_pc_new_model/repository/db/database_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/parts_shop.dart';
import '../../model/pc_parts.dart';
import 'database_constants.dart';

class PcPartsRepository {
  PcPartsRepository._();

  /// PcParts保存
  /// @param pcParts 保存するPcParts
  /// @return 保存したPcPartsのID
  static Future<int> insertPcParts(PcParts pcParts) async {
    final map = {
      PcPartsTableField.id.value: pcParts.id,
      PcPartsTableField.maker.value: pcParts.maker,
      PcPartsTableField.isNew.value: pcParts.isNew ? 1 : 0,
      PcPartsTableField.title.value: pcParts.title,
      PcPartsTableField.star.value: pcParts.star,
      PcPartsTableField.evaluation.value: pcParts.evaluation,
      PcPartsTableField.price.value: pcParts.price,
      PcPartsTableField.ranked.value: pcParts.ranked,
      PcPartsTableField.image.value: pcParts.image,
      PcPartsTableField.detailUrl.value: pcParts.detailUrl,
    };
    final db = await DatabaseModel.database;
    final partsId = await db.insert(
      PcPartsTableField.tableName.value,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _insertPartsShops(pcParts.shops, partsId);
    await _insertPartsSpecs(pcParts.specs, partsId);
    await _insertFullScaleImages(pcParts.fullScaleImages, partsId);
    return partsId;
  }

  /// 店情報保存
  /// @param shops 保存する店情報
  /// @param id 保存するPcPartsのID
  static Future<void> _insertPartsShops(List<PartsShop>? shops, int id) async {
    if (shops == null) {
      return;
    }
    final db = await DatabaseModel.database;
    for (final shop in shops) {
      final map = {
        PartsShopsTableField.partsId.value: id,
        PartsShopsTableField.rank.value: shop.rank,
        PartsShopsTableField.price.value: shop.price,
        PartsShopsTableField.bestPriceDiff.value: shop.bestPriceDiff,
        PartsShopsTableField.name.value: shop.shopName,
        PartsShopsTableField.pageUrl.value: shop.shopPageUrl,
      };
      await db.insert(
        PartsShopsTableField.tableName.value,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// スペック情報保存
  /// @param specs 保存するスペック情報
  /// @param id 保存するPcPartsのID
  static Future<void> _insertPartsSpecs(
      Map<String, String?>? specs, int id,) async {
    if (specs == null) {
      return;
    }
    final db = await DatabaseModel.database;
    specs.forEach((key, value) async {
      final map = {
        PartsSpecsTableField.partsId.value: id,
        PartsSpecsTableField.specName.value: key,
        PartsSpecsTableField.specValue.value: value,
      };
      await db.insert(
        PartsSpecsTableField.tableName.value,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// 画像情報保存
  /// @param images 保存する画像情報
  /// @param id 保存するPcPartsのID
  static Future<void> _insertFullScaleImages(
      List<String>? images, int id,) async {
    if (images == null) {
      return;
    }
    final db = await DatabaseModel.database;
    for (final image in images) {
      final map = {
        FullScaleImagesTableField.partsId.value: id,
        FullScaleImagesTableField.imageUrl.value: image,
      };
      await db.insert(
        FullScaleImagesTableField.tableName.value,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
