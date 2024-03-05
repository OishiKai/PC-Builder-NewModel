import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';
import 'database_model.dart';

class FullScareImageRepository {
  FullScareImageRepository._();
  static final String _tableName = FullScaleImagesTableField.tableName.value;
  static final String _partsId = FullScaleImagesTableField.partsId.value;
  static final String _imageUrl = FullScaleImagesTableField.imageUrl.value;


  /// 画像情報保存
  /// @param images 保存する画像情報
  /// @param id 保存するPcPartsのID
  static Future<void> insertFullScaleImages(
      List<String>? images, String id,) async {
    if (images == null) {
      return;
    }
    final db = await DatabaseModel.database;
    for (final image in images) {
      final map = {
        _partsId: id,
        _imageUrl: image,
      };
      await db.insert(
        _tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// 画像情報取得
  /// @param id 取得するPcPartsのID
  /// @return 取得した画像情報
  static Future<List<String>> selectFullScaleImagesById(String id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_partsId = ?',
      whereArgs: [id],
    );
    final images = <String>[];
    for (final map in maps) {
      images.add(map[_imageUrl] as String);
    }
    return images;
  }
}
