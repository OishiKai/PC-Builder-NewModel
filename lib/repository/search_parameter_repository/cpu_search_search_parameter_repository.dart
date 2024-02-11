import 'package:custom_pc_new_model/model/parts_category.dart';
import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/cpu_search_parameter.dart';
import '../document_repository.dart';
import '../parse_pc_parts/parts_list_search_repository.dart';

class CpuSearchParameterRepository {
  CpuSearchParameterRepository._();

  static const String _selector = '#menu > div.searchspec';
  late Document _document;
  late CpuSearchParameter cpuSearchParameter;

  static Future<CpuSearchParameterRepository> create() async {
    final baseUrl = PartsCategory.cpu.basePartsListUrl();
    final self = CpuSearchParameterRepository._()
      .._document = await DocumentRepository(baseUrl).fetchDocument();
    final makers = self._parseMakerList();
    final processors = self._parseProcessorList();
    final series = self._parseSeriesList();
    final sockets = self._parseSocketList();

    self.cpuSearchParameter = CpuSearchParameter(
      makers,
      processors,
      series,
      sockets,
    );
    return self;
  }

  List<PartsSearchParameter> _parseMakerList() {
    final makerList = <PartsSearchParameter>[];

    final makerListElement = _document
        .querySelectorAll(_selector)[0]
        .querySelectorAll('ul.check.ultop');
    makerList.addAll(
      PartsListSearchParameterRepository(
        makerListElement[1].querySelectorAll('li'),
      ).takeOutParameters(),
    );
    return makerList;
  }

  List<PartsSearchParameter> _parseProcessorList() {
    final processorList = <PartsSearchParameter>[];

    final processorListElement = _document.querySelectorAll(_selector);
    final openProcessorElement =
        processorListElement[0].querySelectorAll('ul.check.ultop');
    // プロセッサー情報は先頭8件がデフォルトで表示されており、それ以降は「もっと見る」を押すことで表示される

    // 先頭8件
    final firstProcessorElement =
        openProcessorElement[2].querySelectorAll('li');
    processorList.addAll(
      PartsListSearchParameterRepository(firstProcessorElement)
          .takeOutParameters(),
    );

    //それ以降
    final afterProcessorElement =
        openProcessorElement[3].querySelectorAll('li');
    processorList.addAll(
      PartsListSearchParameterRepository(afterProcessorElement)
          .takeOutParameters(),
    );

    return processorList;
  }

  List<PartsSearchParameter> _parseSeriesList() {
    final seriesList = <PartsSearchParameter>[];

    final processorListElement = _document.querySelectorAll(_selector);
    final openProcessorElement =
        processorListElement[0].querySelectorAll('ul.check');

    // 世代の情報があるindexを探す
    var seriesNodeIndex = 0;
    for (var i = 0; i < openProcessorElement.length; i++) {
      final sectionName =
          openProcessorElement[i].querySelectorAll('li')[0].text;
      // 先頭が '世代' の場合はindexを保持する
      if (sectionName == '世代') {
        seriesNodeIndex = i;
        break;
      }
    }

    final seriesElement =
        openProcessorElement[seriesNodeIndex].querySelectorAll('li');
    seriesList.addAll(
      PartsListSearchParameterRepository(seriesElement).takeOutParameters(),
    );
    return seriesList;
  }

  List<PartsSearchParameter> _parseSocketList() {
    final socketList = <PartsSearchParameter>[];
    final socketListElement = _document.querySelectorAll(_selector);
    final openSocketElement = socketListElement[0].querySelectorAll('ul.check');

    //ソケットの情報があるindexを探す
    var seriesNodeIndex = 0;
    for (var i = 0; i < openSocketElement.length; i++) {
      final sectionName = openSocketElement[i].querySelectorAll('li')[0].text;
      // 先頭が 'ソケット形状' の場合はindexを保持する
      if (sectionName.contains('ソケット形状')) {
        seriesNodeIndex = i;
        break;
      }
    }

    // ソケット情報は先頭5件がデフォルトで表示されており、それ以降は「もっと見る」を押すことで表示される
    // 先頭5件
    final firstSocketElement =
        openSocketElement[seriesNodeIndex].querySelectorAll('li');
    socketList.addAll(
      PartsListSearchParameterRepository(firstSocketElement)
          .takeOutParameters(),
    );

    //それ以降
    final afterSocketElement =
        openSocketElement[seriesNodeIndex + 1].querySelectorAll('li');
    socketList.addAll(
      PartsListSearchParameterRepository(afterSocketElement)
          .takeOutParameters(),
    );

    return socketList;
  }
}
