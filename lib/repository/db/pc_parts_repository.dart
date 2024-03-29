import 'package:sqflite/sqflite.dart';

import '../../model/parts_category.dart';
import '../../model/pc_parts.dart';
import '../price.dart';
import 'database_constants.dart';
import 'database_model.dart';
import 'full_scale_image_repository.dart';
import 'parts_shop_repository.dart';
import 'parts_spec_repository.dart';

class PcPartsRepository {
  PcPartsRepository._();
  static final String _tableName = PcPartsTableField.tableName.value;
  static final String _id = PcPartsTableField.id.value;
  static final String _category = PcPartsTableField.category.value;
  static final String _maker = PcPartsTableField.maker.value;
  static final String _isNew = PcPartsTableField.isNew.value;
  static final String _title = PcPartsTableField.title.value;
  static final String _star = PcPartsTableField.star.value;
  static final String _evaluation = PcPartsTableField.evaluation.value;
  static final String _price = PcPartsTableField.price.value;
  static final String _ranked = PcPartsTableField.ranked.value;
  static final String _image = PcPartsTableField.image.value;
  static final String _detailUrl = PcPartsTableField.detailUrl.value;

  /// PcParts保存
  /// @param pcParts 保存するPcParts
  static Future<void> insertPcParts(PcParts pcParts) async {
    if (await _isExistPcPartsById(pcParts.id)) {
      return;
    }

    final map = {
      _id: pcParts.id,
      _category: pcParts.category.categoryParameter,
      _maker: pcParts.maker,
      _isNew: pcParts.isNew ? 1 : 0,
      _title: pcParts.title,
      _star: pcParts.star,
      _evaluation: pcParts.evaluation,
      _price: pcParts.price.stringPrice,
      _ranked: pcParts.ranked,
      _image: pcParts.image,
      _detailUrl: pcParts.detailUrl,
    };
    final db = await DatabaseModel.database;
    await db.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await PartsShopRepository.insertPartsShops(
      pcParts.shops,
      pcParts.id,
    );
    await PartsSpecRepository.insertPartsSpecs(
      pcParts.specs,
      pcParts.id,
    );
    await FullScareImageRepository.insertFullScaleImages(
      pcParts.fullScaleImages,
      pcParts.id,
    );
  }

  /// PcParts取得
  /// @param id 取得するPcPartsのID
  /// @return 取得したPcParts
  static Future<PcParts?> selectPcPartsById(String id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }

    final partsMap = maps[0];
    final shops = await PartsShopRepository.selectPartsShopsById(
      partsMap[PartsShopsTableField.partsId.value] as String,
    );
    final specs = await PartsSpecRepository.selectSpecsById(
      partsMap[PartsSpecsTableField.partsId.value] as String,
    );
    final images = await FullScareImageRepository.selectFullScaleImagesById(
      partsMap[FullScaleImagesTableField.partsId] as String,
    );

    final parts = PcParts(
      id: partsMap[_id] as String,
      category: PartsCategory.fromCategoryParameter(
        partsMap[_category] as String,
      ),
      maker: partsMap[_maker] as String,
      isNew: partsMap[_isNew] == 1,
      title: partsMap[_title] as String,
      star: partsMap[_star] as int?,
      evaluation: partsMap[_evaluation] as String?,
      price: Price(partsMap[_price] as String),
      ranked: partsMap[_ranked] as String,
      image: partsMap[_image] as String,
      detailUrl: partsMap[_detailUrl] as String,
      shops: shops,
      specs: specs,
      fullScaleImages: images,
    );
    return parts;
  }

  /// PcPartsがすでに保存済みか
  /// @param id 取得するPcPartsのID
  /// @return 存在するか
  static Future<bool> _isExistPcPartsById(String id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
