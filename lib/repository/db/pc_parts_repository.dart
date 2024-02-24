import 'package:custom_pc_new_model/repository/db/database_model.dart';
import 'package:sqflite/sqflite.dart';

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
      'category': pcParts.category?.categoryName,
    };
    final db = await DatabaseModel.database;
    final partsId = await db.insert(
      'pc_parts',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // await _insertPartsShops(pcParts.shops, partsId);
    // await _insertPartsSpecs(pcParts.specs, partsId);
    // await _insertFullScaleImages(pcParts.fullScaleImages, partsId);
    return partsId;
  }
}
