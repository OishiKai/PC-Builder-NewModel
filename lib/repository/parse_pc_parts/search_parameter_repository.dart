import '../../model/category_search_parameter.dart';
import '../../model/parts_category.dart';
import '../search_parameter_repository/case_fan_search_parameter_repository.dart';
import '../search_parameter_repository/cpu_cooler_search_parameter_repository.dart';
import '../search_parameter_repository/cpu_search_search_parameter_repository.dart';
import '../search_parameter_repository/graphics_card_search_parameter_repository.dart';
import '../search_parameter_repository/memory_search_parameter_repository.dart';
import '../search_parameter_repository/mother_board_search_parameter_repository.dart';
import '../search_parameter_repository/pc_case_search_parameter_repository.dart';
import '../search_parameter_repository/power_unit_search_parameter_repository.dart';
import '../search_parameter_repository/ssd_search_parameter_repository.dart';

class SearchParameterRepository {
  SearchParameterRepository._();
  static Future<Map<PartsCategory, CategorySearchParameter>>
      getAllParams() async {
    final paramMap = <PartsCategory, CategorySearchParameter>{};

    for (final category in PartsCategory.values) {
      switch (category) {
        case PartsCategory.cpu:
          final parser = await CpuSearchParameterRepository.create();
          paramMap[category] = parser.cpuSearchParameter;

        case PartsCategory.cpuCooler:
          final parser = await CpuCoolerSearchParameterRepository.create();
          paramMap[category] = parser.cpuCoolerSearchParameter;

        case PartsCategory.memory:
          final parser = await MemorySearchParameterRepository.create();
          paramMap[category] = parser.memorySearchParameter;

        case PartsCategory.motherboard:
          final parser = await MotherBoardSearchParameterRepository.create();
          paramMap[category] = parser.motherBoardSearchParameter;

        case PartsCategory.graphicsCard:
          final parser = await GraphicsCardSearchParameterRepository.create();
          paramMap[category] = parser.graphicsCardSearchParameter;

        case PartsCategory.ssd:
          final parser = await SsdSearchParameterRepository.create();
          paramMap[category] = parser.ssdSearchParameter;

        case PartsCategory.powerUnit:
          final parser = await PowerUnitSearchParameterRepository.create();
          paramMap[category] = parser.powerUnitSearchParameter;

        case PartsCategory.pcCase:
          final parser = await PcCaseSearchParameterRepository.create();
          paramMap[category] = parser.pcCaseSearchParameter;

        case PartsCategory.caseFan:
          final parser = await CaseFanSearchParameterRepository.create();
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
