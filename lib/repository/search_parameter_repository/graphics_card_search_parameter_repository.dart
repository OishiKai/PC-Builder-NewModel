import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/graphics_card_search_parameter.dart';
import '../document_repository.dart';
import '../parse_pc_parts/parts_list_search_repository.dart';

class GraphicsCardSearchParameterRepository {
  GraphicsCardSearchParameterRepository._();
  static const String _standardPage =
      'https://kakaku.com/pc/videocard/itemlist.aspx';
  static const String _parameterSelector = '#menu > div.searchspec > div';
  late Document _document;
  late GraphicsCardSearchParameter graphicsCardSearchParameter;

  static Future<GraphicsCardSearchParameterRepository> create() async {
    final self = GraphicsCardSearchParameterRepository._()
      .._document = await DocumentRepository(_standardPage).fetchDocument();
    final nvidiaChips = self._parseNvidiaChipList();
    final amdChips = self._parseAmdChips();
    self.graphicsCardSearchParameter = GraphicsCardSearchParameter(
      nvidiaChips,
      amdChips,
    );
    return self;
  }

  List<PartsSearchParameter> _parseNvidiaChipList() {
    final nvidiaChipList = <PartsSearchParameter>[];
    final nvidiaChipListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul');

    // NVIDIAチップのリストは1番目と2番目 div にある
    final headNvidiaChipList = nvidiaChipListElement[0].querySelectorAll('li');
    final tailNvidiaChipList = nvidiaChipListElement[1].querySelectorAll('li');

    nvidiaChipList
      ..addAll(
        PartsListSearchParameterRepository(headNvidiaChipList)
            .takeOutParameters(),
      )
      ..addAll(
        PartsListSearchParameterRepository(tailNvidiaChipList)
            .takeOutParameters(),
      );

    return nvidiaChipList;
  }

  List<PartsSearchParameter> _parseAmdChips() {
    final amdChipList = <PartsSearchParameter>[];
    // AMDチップのリストは3番目の div にある
    final amdChipListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul');

    // AMDチップのリストは3番目と4番目 div にある
    final headAmdChipList = amdChipListElement[2].querySelectorAll('li');
    final tailAmdChipList = amdChipListElement[3].querySelectorAll('li');

    amdChipList
      ..addAll(PartsListSearchParameterRepository(headAmdChipList)
          .takeOutParameters())
      ..addAll(PartsListSearchParameterRepository(tailAmdChipList)
          .takeOutParameters());
    return amdChipList;
  }
}
