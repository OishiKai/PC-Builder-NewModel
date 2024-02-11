import '../model/category_search_parameter.dart';
import '../model/parts_category.dart';
import 'search_parameter_parser/case_fan_search_parameter_parser.dart';
import 'search_parameter_parser/cpu_cooler_search_parameter_parser.dart';
import 'search_parameter_parser/cpu_search_search_parameter_parser.dart';
import 'search_parameter_parser/graphics_card_search_parameter_parser.dart';
import 'search_parameter_parser/memory_search_parameter_parser.dart';
import 'search_parameter_parser/mother_board_search_parameter_parser.dart';
import 'search_parameter_parser/pc_case_search_parameter_parser.dart';
import 'search_parameter_parser/power_unit_search_parameter_parser.dart';
import 'search_parameter_parser/ssd_search_parameter_parser.dart';

class SearchParameterFetcher {
  SearchParameterFetcher._();
  static Future<Map<PartsCategory, CategorySearchParameter>>
      getAllParams() async {
    final paramMap = <PartsCategory, CategorySearchParameter>{};

    for (final category in PartsCategory.values) {
      switch (category) {
        case PartsCategory.cpu:
          final parser = await CpuSearchParameterParser.create();
          paramMap[category] = parser.cpuSearchParameter;

        case PartsCategory.cpuCooler:
          final parser = await CpuCoolerSearchParameterParser.create();
          paramMap[category] = parser.cpuCoolerSearchParameter;

        case PartsCategory.memory:
          final parser = await MemorySearchParameterParser.create();
          paramMap[category] = parser.memorySearchParameter;

        case PartsCategory.motherboard:
          final parser = await MotherBoardSearchParameterParser.create();
          paramMap[category] = parser.motherBoardSearchParameter;

        case PartsCategory.graphicsCard:
          final parser = await GraphicsCardSearchParameterParser.create();
          paramMap[category] = parser.graphicsCardSearchParameter;

        case PartsCategory.ssd:
          final parser = await SsdSearchParameterParser.create();
          paramMap[category] = parser.ssdSearchParameter;

        case PartsCategory.powerUnit:
          final parser = await PowerUnitSearchParameterParser.create();
          paramMap[category] = parser.powerUnitSearchParameter;

        case PartsCategory.pcCase:
          final parser = await PcCaseSearchParameterParser.create();
          paramMap[category] = parser.pcCaseSearchParameter;

        case PartsCategory.caseFan:
          final parser = await CaseFanSearchParameterParser.create();
          paramMap[category] = parser.caseFanSearchParameter;
      }
    }
    return paramMap;
  }

  // 検索条件の選択、クリアの際に利用する
  static Map<PartsCategory, CategorySearchParameter> copyWith(
    Map<PartsCategory, CategorySearchParameter> state,
    PartsCategory category,
    CategorySearchParameter? params,
  ) {
    final newState = Map<PartsCategory, CategorySearchParameter>.from(state);

    if (params != null) {
      newState[category] = params;
    } else {
      for (final cate in PartsCategory.values) {
        newState[cate]!.clearSelectedParameter();
      }
    }
    return newState;
  }
}
