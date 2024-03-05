import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';
import 'database_model.dart';

class PartsSpecRepository {
  PartsSpecRepository._();
  static final String _tableName = PartsSpecsTableField.tableName.value;
  static final String _partsId = PartsSpecsTableField.partsId.value;
  static final String _specName = PartsSpecsTableField.specName.value;
  static final String _specValue = PartsSpecsTableField.specValue.value;

  /// スペック情報保存
  /// @param specs 保存するスペック情報
  /// @param id 保存するPcPartsのID
  static Future<void> insertPartsSpecs(
      Map<String, String?>? specs, String id,) async {
    if (specs == null) {
      return;
    }
    final db = await DatabaseModel.database;
    specs.forEach((key, value) async {
      final map = {
        _partsId: key,
        _specName: value,
        _specValue: value,
      };
      await db.insert(
        _tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// スペック情報取得
  /// @param id 取得するPcPartsのID
  /// @return 取得したスペック情報
  static Future<Map<String, String?>> selectSpecsById(String id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_partsId = ?',
      whereArgs: [id],
    );
    final specs = <String, String?>{};
    for (final map in maps) {
      specs[map[_specName] as String] = map[_specValue] as String?;
    }
    return specs;
  }
}
