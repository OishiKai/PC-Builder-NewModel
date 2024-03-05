import 'package:custom_pc_new_model/repository/db/database_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/parts_shop.dart';
import '../../model/pc_parts.dart';

class PcPartsRepository {
  PcPartsRepository._();

  static Future<int> insertPcParts(PcParts pcParts, String customId) async {
    final map = {
      'custom_id': customId,
      'maker': pcParts.maker,
      'is_new': pcParts.isNew ? 1 : 0,
      'title': pcParts.title,
      'star': pcParts.star,
      'evaluation': pcParts.evaluation,
      'price': pcParts.price,
      'ranked': pcParts.ranked,
      'image': pcParts.image,
      'detail_url': pcParts.detailUrl,
      'category': pcParts.category.categoryName,
    };
    final db = await DatabaseModel.database;
    final partsId = await db.insert(
      'pc_parts',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _insertPartsShops(pcParts.shops, partsId);
    await _insertPartsSpecs(pcParts.specs, partsId);
    await _insertFullScaleImages(pcParts.fullScaleImages, partsId);
    return partsId;
  }

  // 店情報保存
  static Future<void> _insertPartsShops(List<PartsShop>? shops, int id) async {
    if (shops == null) {
      return;
    }
    final db = await DatabaseModel.database;
    for (final shop in shops) {
      final map = {
        'parts_id': id,
        'rank': shop.rank,
        'price': shop.price,
        'best_price_diff': shop.bestPriceDiff,
        'name': shop.shopName,
        'page_url': shop.shopPageUrl,
      };
      await db.insert(
        'parts_shops',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // スペック情報保存
  static Future<void> _insertPartsSpecs(
      Map<String, String?>? specs,
      int id,
      ) async {
    if (specs == null) {
      return;
    }
    final db = await DatabaseModel.database;
    specs.forEach((key, value) async {
      final map = {
        'parts_id': id,
        'spec_name': key,
        'spec_value': value,
      };
      await db.insert(
        'parts_specs',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  // 画像情報保存
  static Future<void> _insertFullScaleImages(
      List<String>? images,
      int id,
      ) async {
    if (images == null) {
      return;
    }
    final db = await DatabaseModel.database;
    for (final image in images) {
      final map = {
        'parts_id': id,
        'image_url': image,
      };
      await db.insert(
        'full_scale_images',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
