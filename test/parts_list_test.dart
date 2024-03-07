import 'package:custom_pc_new_model/model/parts_category.dart';
import 'package:custom_pc_new_model/repository/parse_pc_parts/parts_list_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';

void main() {
  group('PartsListRepository', () {
    test('fetch cpu parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.cpu;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch cpu cooler parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.cpuCooler;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch memory parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.memory;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch motherboard parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.motherboard;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch graphics card parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.graphicsCard;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch ssd parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.ssd;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch pc case parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.pcCase;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch power unit parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.powerUnit;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });

    test('fetch case fan parts list', () async {
      WidgetsFlutterBinding.ensureInitialized();
      const targetCategory = PartsCategory.caseFan;
      final partsList = await PartsListRepository(
        targetCategory.basePartsListUrl(),
        targetCategory,
      ).fetch();
      expect(partsList.length, 40);
    });
  });
}
