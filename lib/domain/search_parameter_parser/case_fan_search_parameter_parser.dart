import 'package:custom_pc_new_model/model/parts_category.dart';
import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/case_fan_search_parameter.dart';
import '../document_repository.dart';
import '../parts_list_search_parameter.dart';

class CaseFanSearchParameterParser {
  CaseFanSearchParameterParser._();

  static const String _parameterSelector = '#menu > div.searchspec > div';
  late Document _document;
  late CaseFanSearchParameter caseFanSearchParameter;

  static Future<CaseFanSearchParameterParser> create() async {
    final self = CaseFanSearchParameterParser._();
    final basePageUrl = PartsCategory.caseFan.basePartsListUrl();
    self._document = await DocumentRepository(basePageUrl).fetchDocument();

    final makers = self._parseMaker();
    final size = self._parseSize();
    final airVolume = self._parseAirVolume();
    self.caseFanSearchParameter = CaseFanSearchParameter(
      makers,
      size,
      airVolume,
    );
    return self;
  }

  List<PartsSearchParameter> _parseMaker() {
    final makerList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[2]
        .querySelectorAll('ul');
    // デフォルトで表示されている部分
    final makerListElement = specListElement[0].querySelectorAll('li');
    // 「もっと見る」を押した後に表示される部分
    final makerListElementHidden = specListElement[1].querySelectorAll('li');

    makerList
      ..addAll(PartsListSearchParameter(makerListElement).takeOutParameters())
      ..addAll(
        PartsListSearchParameter(makerListElementHidden).takeOutParameters(),
      );
    return makerList;
  }

  List<PartsSearchParameter> _parseSize() {
    final sizeList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul');
    final sizeListElement = specListElement[0].querySelectorAll('li');

    sizeList.addAll(
      PartsListSearchParameter(sizeListElement).takeOutParameters(),
    );
    return sizeList;
  }

  List<PartsSearchParameter> _parseAirVolume() {
    final airVolumeList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul');
    final airVolumeListElement = specListElement[2].querySelectorAll('li');

    airVolumeList.addAll(
      PartsListSearchParameter(airVolumeListElement).takeOutParameters(),
    );
    return airVolumeList;
  }
}
