import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/memory_search_parameter.dart';
import '../document_repository.dart';
import '../parts_list_search_parameter.dart';

class MemorySearchParameterParser {
  MemorySearchParameterParser._();
  static const String _standardPage =
      'https://kakaku.com/pc/pc-memory/itemlist.aspx';
  static const String _parameterSelector = '#menu > div.searchspec > div';
  late Document _document;
  late MemorySearchParameter memorySearchParameter;

  static Future<MemorySearchParameterParser> create() async {
    final self = MemorySearchParameterParser._()
      .._document = await DocumentRepository(_standardPage).fetchDocument();
    final volume = self._parseVolumeList();
    final interface = self._parseInterfaceList();
    final type = self._parseTypeList();
    self.memorySearchParameter = MemorySearchParameter(volume, interface, type);
    return self;
  }

  List<PartsSearchParameter> _parseVolumeList() {
    final volumeList = <PartsSearchParameter>[];
    // 容量のリストは3番目の div の中の 1番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul')[0];
    final volumeListElement = specListElement.querySelectorAll('li');

    volumeList.addAll(
      PartsListSearchParameter(volumeListElement).takeOutParameters(),
    );
    return volumeList;
  }

  List<PartsSearchParameter> _parseInterfaceList() {
    final interfaceList = <PartsSearchParameter>[];
    // インターフェースのリストは3番目の div の中の 2番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul')[2];
    final interfaceListElement = specListElement.querySelectorAll('li');

    interfaceList.addAll(
      PartsListSearchParameter(interfaceListElement).takeOutParameters(),
    );
    return interfaceList;
  }

  List<PartsSearchParameter> _parseTypeList() {
    final typeList = <PartsSearchParameter>[];
    // タイプのリストは3番目の div の中の 3番目の ul にある
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul')[3];
    final typeListElement = specListElement.querySelectorAll('li');

    typeList.addAll(
      PartsListSearchParameter(typeListElement).takeOutParameters(),
    );
    return typeList;
  }
}
