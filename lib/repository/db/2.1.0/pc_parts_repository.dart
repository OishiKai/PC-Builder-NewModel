import 'package:custom_pc_new_model/model/parts_category.dart';
import 'package:custom_pc_new_model/repository/db/2.1.0/databese_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/parts_shop.dart';
import '../../../model/pc_parts.dart';

class PcPartsRepository {
  PcPartsRepository._();
  // PcParts保存
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
    };
    final db = await DatabaseModel.database;
    final partsId = await db.insert(
      'pc_parts',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 店情報、スペック情報、画像情報を保存
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

  // PcParts取得
  static Future<List<PcParts>> getAllPcParts() async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query('pc_parts');
    final pcParts = <PcParts>[];
    for (final map in maps) {
      // 店、スペック、画像情報取得
      final shops = await _selectPartsShopsById(map['id'] as int);
      final specs = await _partsSpecs(map['id'] as int);
      final images = await _selectFullScaleImagesById(map['id'] as int);
      // PcPartsオブジェクト化
      pcParts.add(
        PcParts(
          maker: map['maker'] as String,
          isNew: map['is_new'] == 1,
          title: map['title'] as String,
          star: map['star'] as int?,
          evaluation: map['evaluation'] as String?,
          price: map['price'] as String,
          ranked: map['ranked'] as String,
          image: map['image'] as String,
          detailUrl: map['detail_url'] as String,
          shops: shops,
          specs: specs,
          fullScaleImages: images,
          category: PartsCategory.cpu,
          id: '',
        ),
      );
    }
    return pcParts;
  }

  static Future<PcParts?> selectPcPartsById(int? id) async {
    if (id == null) {
      return null;
    }
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pc_parts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    final shops = await _selectPartsShopsById(maps[0]['id'] as int);
    final specs = await _partsSpecs(maps[0]['id'] as int);
    final images = await _selectFullScaleImagesById(maps[0]['id'] as int);
    final i = PcParts(
      maker: maps[0]['maker'] as String,
      isNew: maps[0]['is_new'] == 1,
      title: maps[0]['title'] as String,
      star: maps[0]['star'] as int?,
      evaluation: maps[0]['evaluation'] as String?,
      price: maps[0]['price'] as String,
      ranked: maps[0]['ranked'] as String,
      image: maps[0]['image'] as String,
      detailUrl: maps[0]['detail_url'] as String,
      shops: shops,
      specs: specs,
      fullScaleImages: images,
      category: PartsCategory.cpu,
      id: '',
    );
    return i;
  }

  // 削除
  static Future<void> deletePcParts(int id) async {
    final db = await DatabaseModel.database;
    await _deletePartsShops(id);
    await _deletePartsSpecs(id);
    await _deleteFullScaleImages(id);
    await db.delete(
      'pc_parts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 店情報取得
  static Future<List<PartsShop>> _selectPartsShopsById(int id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'parts_shops',
      where: 'parts_id = ?',
      whereArgs: [id],
    );
    final shops = <PartsShop>[];
    for (final map in maps) {
      shops.add(
        PartsShop(
          map['rank'] as String,
          map['price'] as String,
          map['best_price_diff'] as String,
          map['name'] as String,
          map['page_url'] as String,
        ),
      );
    }
    return shops;
  }

  //　店情報削除
  static Future<void> _deletePartsShops(int id) async {
    final db = await DatabaseModel.database;
    await db.delete(
      'parts_shops',
      where: 'parts_id = ?',
      whereArgs: [id],
    );
  }

  // スペック情報取得
  static Future<Map<String, String?>> _partsSpecs(int id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'parts_specs',
      where: 'parts_id = ?',
      whereArgs: [id],
    );
    final specs = <String, String?>{};
    for (final map in maps) {
      specs[map['spec_name'] as String] = map['spec_value'] as String?;
    }
    return specs;
  }

  // スペック情報削除
  static Future<void> _deletePartsSpecs(int id) async {
    final db = await DatabaseModel.database;
    await db.delete(
      'parts_specs',
      where: 'parts_id = ?',
      whereArgs: [id],
    );
  }

  // 画像情報取得
  static Future<List<String>> _selectFullScaleImagesById(int id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'full_scale_images',
      where: 'parts_id = ?',
      whereArgs: [id],
    );
    final images = <String>[];
    for (final map in maps) {
      images.add(map['image_url'] as String);
    }
    return images;
  }

  // 画像情報削除
  static Future<void> _deleteFullScaleImages(int id) async {
    final db = await DatabaseModel.database;
    await db.delete(
      'full_scale_images',
      where: 'parts_id = ?',
      whereArgs: [id],
    );
  }
}
