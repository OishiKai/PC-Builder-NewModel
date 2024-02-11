import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/ssd_search_parameter.dart';
import '../document_repository.dart';
import '../parse_pc_parts/parts_list_search_repository.dart';

class SsdSearchParameterParser {
  SsdSearchParameterParser._();
  static const String standardPage = 'https://kakaku.com/pc/ssd/itemlist.aspx';
  static const String _parameterSelector = '#menu > div.searchspec > div';

  late Document _document;
  late SsdSearchParameter ssdSearchParameter;

  static Future<SsdSearchParameterParser> create() async {
    final self = SsdSearchParameterParser._()
      .._document = await DocumentRepository(standardPage).fetchDocument();
    final volumes = self._parseVolume();
    final types = self._parseType();
    final interfaces = self._parseInterface();
    self.ssdSearchParameter = SsdSearchParameter(volumes, types, interfaces);
    return self;
  }

  List<PartsSearchParameter> _parseVolume() {
    final volumeList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[5]
        .querySelectorAll('ul');
    final volumeListElement = specListElement[0].querySelectorAll('li');
    volumeList.addAll(
      PartsListSearchParameterRepository(volumeListElement).takeOutParameters(),
    );
    return volumeList;
  }

  List<PartsSearchParameter> _parseType() {
    final typeList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[5]
        .querySelectorAll('ul');
    final typeListElement = specListElement[1].querySelectorAll('li');
    typeList.addAll(
      PartsListSearchParameterRepository(typeListElement).takeOutParameters(),
    );
    return typeList;
  }

  List<PartsSearchParameter> _parseInterface() {
    final interfaceList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[5]
        .querySelectorAll('ul');
    final interfaceListElement = specListElement[2].querySelectorAll('li');
    interfaceList.addAll(
      PartsListSearchParameterRepository(interfaceListElement)
          .takeOutParameters(),
    );
    return interfaceList;
  }
}
