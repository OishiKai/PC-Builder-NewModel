import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/mother_board_search_parameter.dart';
import '../document_repository.dart';
import '../parts_list_search_parameter.dart';

class MotherBoardSearchParameterParser {
  MotherBoardSearchParameterParser._();
  static const String _standardPage =
      'https://kakaku.com/pc/motherboard/itemlist.aspx';
  static const String _parameterSelector = '#menu > div.searchspec > div';

  late Document _document;
  late MotherBoardSearchParameter motherBoardSearchParameter;
  static Future<MotherBoardSearchParameterParser> create() async {
    final self = MotherBoardSearchParameterParser._()
      .._document = await DocumentRepository(_standardPage).fetchDocument();
    final intelSockets = self._parseIntelSockets();
    final amdSockets = self._parseAmdSockets();
    final formFactors = self._parseFormFactor();
    final memoryType = self._parseMemoryTypes();
    self.motherBoardSearchParameter = MotherBoardSearchParameter(
      intelSockets,
      amdSockets,
      formFactors,
      memoryType,
    );
    return self;
  }

  List<PartsSearchParameter> _parseIntelSockets() {
    final intelSocketList = <PartsSearchParameter>[];
    // CPUソケット(intel)のリストは3番目の div の中の 2番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul');
    final firstIntelSocketListElement =
        specListElement[5].querySelectorAll('li');
    final afterIntelSocketListElement =
        specListElement[6].querySelectorAll('li');

    // CPUソケット(intel)情報は2つの ul に分かれているので、それぞれの ul に対して処理を行う
    // 先頭
    intelSocketList
      ..addAll(
        PartsListSearchParameter(firstIntelSocketListElement)
            .takeOutParameters(),
      )
      ..addAll(
        PartsListSearchParameter(afterIntelSocketListElement)
            .takeOutParameters(),
      );
    return intelSocketList;
  }

  List<PartsSearchParameter> _parseAmdSockets() {
    final amdSocketList = <PartsSearchParameter>[];
    // CPUソケット(AMD)のリストは3番目の div の中の 2番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul');
    final firstAmdSocketListElement = specListElement[7].querySelectorAll('li');
    final afterAmdSocketListElement = specListElement[8].querySelectorAll('li');

    // CPUソケット(AMD)のリストは2つに分かれているので、それぞれのリストごとに処理する
    amdSocketList
      ..addAll(
        PartsListSearchParameter(firstAmdSocketListElement).takeOutParameters(),
      )
      ..addAll(
        PartsListSearchParameter(afterAmdSocketListElement).takeOutParameters(),
      );
    return amdSocketList;
  }

  List<PartsSearchParameter> _parseFormFactor() {
    final formFactorList = <PartsSearchParameter>[];
    // フォームファクターのリストは3番目の div の中の 2番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul');
    final firstFormFactorListElement =
        specListElement[9].querySelectorAll('li');
    final afterFormFactorListElement =
        specListElement[10].querySelectorAll('li');

    // フォームファクターのリストは2つに分かれているので、それぞれのリストごとに処理する
    // 先頭
    formFactorList
      ..addAll(
        PartsListSearchParameter(firstFormFactorListElement)
            .takeOutParameters(),
      )
      ..addAll(
        PartsListSearchParameter(afterFormFactorListElement)
            .takeOutParameters(),
      );
    return formFactorList;
  }

  List<PartsSearchParameter> _parseMemoryTypes() {
    final memoryTypeList = <PartsSearchParameter>[];
    // メモリタイプのリストは3番目の div の中の 2番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[3]
        .querySelectorAll('ul');
    final firstMemoryTypeListElement =
        specListElement[11].querySelectorAll('li');

    memoryTypeList.addAll(
      PartsListSearchParameter(firstMemoryTypeListElement).takeOutParameters(),
    );
    return memoryTypeList;
  }
}
