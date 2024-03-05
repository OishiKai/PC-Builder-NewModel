import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../model/custom.dart';
import '../../../model/parts_category.dart';
import '../../../model/pc_parts.dart';
import 'databese_model.dart';
import 'pc_parts_repository.dart';

class CustomRepository210 {
  CustomRepository210._();
  //Custom保存
  static Future<int> insertCustom(Custom custom) async {
    // custom_idを生成
    final customId = const Uuid().v4();
    // 含まれるパーツのidを保持するMap
    final partsIdMap = <PartsCategory, Future<int>>{};

    custom.parts?.forEach((parts) {
      // 各パーツを保存して、idを保持
      final partsId = PcPartsRepository210.insertPcParts(parts, customId);
      partsIdMap[parts.category] = partsId;
    });

    final db = await DatabaseModel210.database;

    final map = {
      'id': customId,
      'name': custom.name,
      'price': custom.calculateTotalPrice(),
      'cpu_id': await partsIdMap[PartsCategory.cpu],
      'cpu_cooler_id': await partsIdMap[PartsCategory.cpuCooler],
      'memory_id': await partsIdMap[PartsCategory.memory],
      'mother_board_id': await partsIdMap[PartsCategory.motherboard],
      'graphics_card_id': await partsIdMap[PartsCategory.graphicsCard],
      'ssd_id': await partsIdMap[PartsCategory.ssd],
      'pc_case_id': await partsIdMap[PartsCategory.pcCase],
      'power_unit_id': await partsIdMap[PartsCategory.powerUnit],
      'case_fan_id': await partsIdMap[PartsCategory.caseFan],
      'date':
          '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
    };
    // カスタム情報を保存
    return db.insert(
      'custom',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Custom取得
  static Future<Map<String, Custom>> getAllCustoms() async {
    final db = await DatabaseModel210.database;
    final stored = await db.query('custom');
    if (stored.isEmpty) {
      return {};
    }

    final customList = <String, Custom>{};
    for (final custom in stored) {
      final id = custom['id']! as String;
      final name = custom['name']! as String;
      final price = custom['price']! as String;
      final date = custom['date']! as String;

      final cpu = await PcPartsRepository210.selectPcPartsById(
        custom['cpu_id'] as int?,
      );
      final cpuCooler = await PcPartsRepository210.selectPcPartsById(
        custom['cpu_cooler_id'] as int?,
      );
      final memory = await PcPartsRepository210.selectPcPartsById(
        custom['memory_id'] as int?,
      );
      final motherBoard = await PcPartsRepository210.selectPcPartsById(
        custom['mother_board_id'] as int?,
      );
      final graphicsCard = await PcPartsRepository210.selectPcPartsById(
        custom['graphics_card_id'] as int?,
      );
      final ssd = await PcPartsRepository210.selectPcPartsById(
        custom['ssd_id'] as int?,
      );
      final pcCase = await PcPartsRepository210.selectPcPartsById(
        custom['pc_case_id'] as int?,
      );
      final powerUnit = await PcPartsRepository210.selectPcPartsById(
        custom['power_unit_id'] as int?,
      );
      final caseFan = await PcPartsRepository210.selectPcPartsById(
        custom['case_fan_id'] as int?,
      );

      final parts = [
        cpu,
        cpuCooler,
        memory,
        motherBoard,
        graphicsCard,
        ssd,
        pcCase,
        powerUnit,
        caseFan,
      ];

      customList[id] = Custom(
        id: id,
        name: name,
        totalPrice: price,
        parts: parts.whereType<PcParts>().toList(),
        date: date,
      );
    }
    return customList;
  }

  // Custom削除
  static Future<void> deleteCustom(String id) async {
    await deleteIncludeParts(id);
    final db = await DatabaseModel210.database;
    await db.delete(
      'custom',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Custom更新
  static Future<void> updateCustom(String customId, Custom custom) async {
    final db = await DatabaseModel210.database;
    await deleteIncludeParts(customId);

    final partsIdMap = <PartsCategory, Future<int>>{};
    custom.parts?.forEach((parts) {
      // 各パーツを保存して、idを保持
      final partsId = PcPartsRepository210.insertPcParts(parts, customId);
      partsIdMap[parts.category] = partsId;
    });

    final map = {
      'id': customId,
      'name': custom.name,
      'price': custom.calculateTotalPrice(),
      'cpu_id': await partsIdMap[PartsCategory.cpu],
      'cpu_cooler_id': await partsIdMap[PartsCategory.cpuCooler],
      'memory_id': await partsIdMap[PartsCategory.memory],
      'mother_board_id': await partsIdMap[PartsCategory.motherboard],
      'graphics_card_id': await partsIdMap[PartsCategory.graphicsCard],
      'ssd_id': await partsIdMap[PartsCategory.ssd],
      'pc_case_id': await partsIdMap[PartsCategory.pcCase],
      'power_unit_id': await partsIdMap[PartsCategory.powerUnit],
      'case_fan_id': await partsIdMap[PartsCategory.caseFan],
      'date':
          '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
    };
    // カスタム情報を更新
    await db.update(
      'custom',
      map,
      where: 'id = ?',
      whereArgs: [customId],
    );
  }

  // Customに含まれるparts_id取得->全パーツ削除
  static Future<Map<PartsCategory, int?>> deleteIncludeParts(
    String customId,
  ) async {
    final db = await DatabaseModel210.database;
    final stored = await db.query(
      'custom',
      where: 'id = ?',
      whereArgs: [customId],
    );
    if (stored.isEmpty) {
      return {};
    }

    final partsIdMap = <PartsCategory, int?>{};
    partsIdMap[PartsCategory.cpu] = stored[0]['cpu_id'] as int?;
    partsIdMap[PartsCategory.cpuCooler] = stored[0]['cpu_cooler_id'] as int?;
    partsIdMap[PartsCategory.memory] = stored[0]['memory_id'] as int?;
    partsIdMap[PartsCategory.motherboard] =
        stored[0]['mother_board_id'] as int?;
    partsIdMap[PartsCategory.graphicsCard] =
        stored[0]['graphics_card_id'] as int?;
    partsIdMap[PartsCategory.ssd] = stored[0]['ssd_id'] as int?;
    partsIdMap[PartsCategory.pcCase] = stored[0]['pc_case_id'] as int?;
    partsIdMap[PartsCategory.powerUnit] = stored[0]['power_unit_id'] as int?;
    partsIdMap[PartsCategory.caseFan] = stored[0]['case_fan_id'] as int?;

    // idがnullでない場合はパーツを削除
    partsIdMap.forEach((category, partsId) async {
      if (partsId != null) {
        await PcPartsRepository210.deletePcParts(partsId);
      }
    });
    return partsIdMap;
  }

  // v2 Custom取得
  static Future<List<Custom>> getAllCustomsV2() async {
    final db = await DatabaseModel210.database;
    final stored = await db.query('custom');
    if (stored.isEmpty) {
      return [];
    }

    final customList = <Custom>[];
    for (final custom in stored) {
      final id = custom['id']! as String;
      final name = custom['name']! as String;
      final price = custom['price']! as String;
      final date = custom['date']! as String;

      final cpu = await PcPartsRepository210.selectPcPartsById(
        custom['cpu_id'] as int?,
      );
      final cpuCooler = await PcPartsRepository210.selectPcPartsById(
        custom['cpu_cooler_id'] as int?,
      );
      final memory = await PcPartsRepository210.selectPcPartsById(
        custom['memory_id'] as int?,
      );
      final motherBoard = await PcPartsRepository210.selectPcPartsById(
        custom['mother_board_id'] as int?,
      );
      final graphicsCard = await PcPartsRepository210.selectPcPartsById(
        custom['graphics_card_id'] as int?,
      );
      final ssd = await PcPartsRepository210.selectPcPartsById(
        custom['ssd_id'] as int?,
      );
      final pcCase = await PcPartsRepository210.selectPcPartsById(
        custom['pc_case_id'] as int?,
      );
      final powerUnit = await PcPartsRepository210.selectPcPartsById(
        custom['power_unit_id'] as int?,
      );
      final caseFan = await PcPartsRepository210.selectPcPartsById(
        custom['case_fan_id'] as int?,
      );

      final parts = [
        cpu,
        cpuCooler,
        memory,
        motherBoard,
        graphicsCard,
        ssd,
        pcCase,
        powerUnit,
        caseFan,
      ];

      customList.add(
        Custom(
          id: id,
          name: name,
          totalPrice: price,
          parts: parts.whereType<PcParts>().toList(),
          date: date,
        ),
      );
    }
    return customList;
  }
}
