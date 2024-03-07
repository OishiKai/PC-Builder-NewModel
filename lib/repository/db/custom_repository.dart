import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../model/custom.dart';
import '../../model/pc_parts.dart';
import '../../repository/db/pc_parts_repository.dart';
import '../../repository/price.dart';
import 'database_constants.dart';
import 'database_model.dart';

class CustomRepository {
  CustomRepository._();
  static final String _tableName = CustomTableField.tableName.value;
  static final String _id = CustomTableField.id.value;
  static final String _name = CustomTableField.name.value;
  static final String _price = CustomTableField.price.value;
  static final String _date = CustomTableField.date.value;

  /// カスタム情報保存
  /// @param 保存するカスタム
  static Future<void> insertCustom(Custom custom) async {
    if (custom.parts == null) {
      return;
    }
    if (custom.parts!.isEmpty) {
      return;
    }
    final customId = const Uuid().v4();
    final db = await DatabaseModel.database;
    final map = {
      _id: customId,
      _name: custom.name,
      _price: Price(custom.calculateTotalPrice()).stringPrice,
      _date: '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
    };
    await db.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final parts in custom.parts!) {
      await PcPartsRepository.insertPcParts(parts);
      await _insertCustomPartsRelation(customId, parts.id);
    }

    if (kDebugMode) {
      print(
        'insertCustom: ${custom.name}, contains ${custom.parts!.length} parts.',
      );
    }
  }

  /// カスタムとパーツの関係情報保存
  /// @param customId 保存するカスタムのID
  /// @param partsId 保存するPcPartsのID
  static Future<void> _insertCustomPartsRelation(
      String customId, String partsId,) async {
    final db = await DatabaseModel.database;
    final map = {
      CustomPartsRelationTableField.customId.value: customId,
      CustomPartsRelationTableField.partsId.value: partsId,
    };
    await db.insert(
      CustomPartsRelationTableField.tableName.value,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 全カスタム取得
  /// @param id 取得するPcPartsのID
  /// @return 取得したカスタム情報
  static Future<List<Custom>> getAllCustoms(String id) async {
    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> mapList = await db.query(_tableName);
    final customList = <Custom>[];
    for (final map in mapList) {
      final id = map[_id] as String;
      final name = map[_name] as String;
      final price = map[_price] as String;
      final date = map[_date] as String;
      final partsIdList = await _selectCustomPartsRelation(id);
      final partsList = <PcParts>[];
      for (final partsId in partsIdList) {
        final parts = await PcPartsRepository.selectPcPartsById(partsId);
        if (parts != null) {
          partsList.add(parts);
        }
      }
      customList.add(
        Custom(
          id: id,
          name: name,
          parts: partsList,
          totalPrice: Price(price),
          date: date,
        ),
      );
    }
    return customList;
  }

  /// カスタムとパーツの関係情報取得
  /// @param customId 取得するカスタムのID
  /// @return 取得したPcPartsのID
  static Future<List<String>> _selectCustomPartsRelation(
      String customId,) async {

    final db = await DatabaseModel.database;
    final List<Map<String, dynamic>> maps = await db.query(
      CustomPartsRelationTableField.tableName.value,
      where: '${CustomPartsRelationTableField.customId.value} = ?',
      whereArgs: [customId],
    );
    final partsIdList = <String>[];
    for (final map in maps) {
      partsIdList.add(
        map[CustomPartsRelationTableField.partsId.value] as String,
      );
    }
    return partsIdList;
  }
}
