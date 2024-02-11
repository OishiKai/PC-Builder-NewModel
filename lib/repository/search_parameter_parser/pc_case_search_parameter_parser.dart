import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/pc_case_search_parameter.dart';
import '../document_repository.dart';
import '../parts_list_search_parameter.dart';

class PcCaseSearchParameterParser {
  PcCaseSearchParameterParser._();
  static const String _standardPage =
      'https://kakaku.com/pc/pc-case/itemlist.aspx';
  static const String _parameterSelector = '#menu > div.searchspec > div';
  late Document _document;
  late PcCaseSearchParameter pcCaseSearchParameter;

  static Future<PcCaseSearchParameterParser> create() async {
    final self = PcCaseSearchParameterParser._()
      .._document = await DocumentRepository(_standardPage).fetchDocument();
    final supportMotherBoards = self._parseSupportMotherBoard();
    final supportGraphicsCard = self._parseSupportGraphicsCard();
    final colors = self._parseColors();

    self.pcCaseSearchParameter = PcCaseSearchParameter(
      supportMotherBoards,
      supportGraphicsCard,
      colors,
    );
    return self;
  }

  List<PartsSearchParameter> _parseSupportMotherBoard() {
    final supportMotherBoardList = <PartsSearchParameter>[];
    // fetchSearchParameter() で _document に値が入っていることを保証しているので、nullチェックは不要
    final supportMBListElement = _document
        .querySelectorAll(_parameterSelector)[4]
        .querySelectorAll('ul > li');
    supportMotherBoardList.addAll(
      PartsListSearchParameter(supportMBListElement).takeOutParameters(),
    );
    return supportMotherBoardList;
  }

  List<PartsSearchParameter> _parseSupportGraphicsCard() {
    final supportGraphicsCardList = <PartsSearchParameter>[];
    final supportGraphicsCardListElement = _document
        .querySelectorAll(_parameterSelector)[7]
        .querySelectorAll('ul > li');

    for (final element in supportGraphicsCardListElement) {
      final supportGraphicsCardName = element.text.split('（')[0];
      final supportGraphicsCardParameterAtag = element.querySelectorAll('a');

      if (supportGraphicsCardParameterAtag.isNotEmpty) {
        final supportGraphicsCardParameter = supportGraphicsCardParameterAtag[0]
            .attributes['href']!
            .split('?')[1];

        // 最大グラフィックボードサイズ以外の情報の場合はループを抜ける
        if (supportGraphicsCardParameter.contains('Spec308')) {
          break;
        }
        supportGraphicsCardList.add(
          PartsSearchParameter(
            supportGraphicsCardName,
            supportGraphicsCardParameter,
          ),
        );
      } else if (element.querySelectorAll('span').isNotEmpty) {
        final supportGraphicsCardParameter =
            element.querySelectorAll('span')[0].attributes['onclick']!;
        final split = supportGraphicsCardParameter
            .split("changeLocation('")[1]
            .split("');")[0];

        // 最大グラフィックボードサイズ以外の情報の場合はループを抜ける
        if (supportGraphicsCardParameter.contains('Spec308')) {
          break;
        }
        supportGraphicsCardList
            .add(PartsSearchParameter(supportGraphicsCardName, split));
      }
    }
    return supportGraphicsCardList;
  }

  List<PartsSearchParameter> _parseColors() {
    final colorsList = <PartsSearchParameter>[];
    final colorsListElement = _document
        .querySelectorAll(_parameterSelector)[12]
        .querySelectorAll('ul > li');

    for (final element in colorsListElement) {
      final colorsName = element.text.split('(')[0];
      if (colorsName.contains('その他')) {
        break;
      }
      final colorsParameterAtag = element.querySelectorAll('a');

      if (colorsParameterAtag.isNotEmpty) {
        final colorsParameter =
            colorsParameterAtag[0].attributes['href']!.split('?')[1];
        colorsList.add(PartsSearchParameter(colorsName, colorsParameter));
      } else if (element.querySelectorAll('span').isNotEmpty) {
        final colorsParameter =
            element.querySelectorAll('span')[0].attributes['onclick']!;
        final split =
            colorsParameter.split("changeLocation('")[1].split("');")[0];
        colorsList.add(PartsSearchParameter(colorsName, split));
      }
    }
    return colorsList;
  }
}
