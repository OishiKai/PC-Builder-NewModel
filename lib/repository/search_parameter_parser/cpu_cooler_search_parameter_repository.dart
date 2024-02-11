import 'package:custom_pc_new_model/model/parts_category.dart';
import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/cpu_cooler_search_parameter.dart';
import '../document_repository.dart';
import '../parse_pc_parts/parts_list_search_repository.dart';

class CpuCoolerSearchParameterRepository {
  CpuCoolerSearchParameterRepository._();

  static const String _parameterSelector = '#menu > div.searchspec > div';
  late Document _document;
  late CpuCoolerSearchParameter cpuCoolerSearchParameter;

  static Future<CpuCoolerSearchParameterRepository> create() async {
    final self = CpuCoolerSearchParameterRepository._();
    final basePageUrl = PartsCategory.cpuCooler.basePartsListUrl();
    self._document = await DocumentRepository(basePageUrl).fetchDocument();
    final makers = self._parseMakerList();
    final intelSockets = self._parseIntelSocketList();
    final amdSockets = self._parseAmdSocketList();
    final type = [
      PartsSearchParameter('トップフロー型', 'pdf_Spec101=1'),
      PartsSearchParameter('サイドフロー型', 'pdf_Spec101=2'),
      PartsSearchParameter('水冷型', 'pdf_Spec101=3'),
    ];
    self.cpuCoolerSearchParameter = CpuCoolerSearchParameter(
      makers,
      intelSockets,
      amdSockets,
      type,
    );
    return self;
  }

  List<PartsSearchParameter> _parseMakerList() {
    final makerList = <PartsSearchParameter>[];
    // メーカー名のリストは3番目の div にある
    final makerListElement = _document
        .querySelectorAll(_parameterSelector)[2]
        .querySelectorAll('ul > li');
    makerList.addAll(
      PartsListSearchParameterRepository(makerListElement).takeOutParameters(),
    );
    return makerList;
  }

  List<PartsSearchParameter> _parseIntelSocketList() {
    final intelSocketList = <PartsSearchParameter>[];
    // インテルソケットのリストは4番目の div にある
    final intelSocketListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul > li');
    intelSocketList.addAll(
      PartsListSearchParameterRepository(intelSocketListElement)
          .takeOutParameters(),
    );
    return intelSocketList;
  }

  List<PartsSearchParameter> _parseAmdSocketList() {
    final amdSocketList = <PartsSearchParameter>[];
    // AMDソケットのリストは5番目の div にある
    final amdSocketListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul > li');
    amdSocketList.addAll(
      PartsListSearchParameterRepository(amdSocketListElement)
          .takeOutParameters(),
    );
    return amdSocketList;
  }
}
