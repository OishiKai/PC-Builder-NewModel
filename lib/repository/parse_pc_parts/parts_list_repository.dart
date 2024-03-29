import 'package:html/dom.dart';

import '../../model/parts_category.dart';
import '../../model/pc_parts.dart';
import '../document_repository.dart';
import '../price.dart';

class PartsListRepository {
  PartsListRepository(this.url, this.category);
  final String url;
  final PartsCategory category;
  static const _partsListSelector = '#compTblList > tbody > tr.tr-border';
  static const _partsMakerSelector =
      'td.end.checkItem > table > tbody > tr > td.ckitemLink > a > span';
  static const _partsCombinedMakerAndTitleSelector =
      'td.end.checkItem > table > tbody > tr > td.ckitemLink > a';
  static const _partsNewSelector =
      'td.end.checkItem > table > tbody > tr > td.ckitemLink > img';
  static const _partsImageUrlSelector = 'td.alignC > a > img';
  static const _partsDetailUrlSelector = 'td.alignC > a';
  static const _partsPriceSelector = 'td.td-price > ul > li.pryen > a';
  static const _patsRankedSelector = 'td.swrank2 > span';

  Future<List<PcParts>> fetch() async {
    final document = await DocumentRepository(url).fetchDocument();
    final partsList = _parsePartsList(document, category);
    return partsList;
  }

  static List<PcParts> _parsePartsList(
    Document document,
    PartsCategory category,
  ) {
    final partsList = <PcParts>[];
    final partsListElement = document.querySelectorAll(_partsListSelector);

    for (var i = 1; i < partsListElement.length; i += 3) {
      final maker =
          partsListElement[i].querySelectorAll(_partsMakerSelector)[0].text;
      // 商品名を直接取得できず、"{メーカー名} {商品名}"という形式で取得し、"{メーカー名} "を除く
      final combined = partsListElement[i]
          .querySelectorAll(_partsCombinedMakerAndTitleSelector)[0]
          .text;
      final title = combined.replaceFirst(maker, '');
      final isNew =
          partsListElement[i].querySelectorAll(_partsNewSelector).isNotEmpty;
      final imageUrl = partsListElement[i + 1]
          .querySelectorAll(_partsImageUrlSelector)[0]
          .attributes['src']!
          .replaceFirst('/m/', '/ll/');
      final detailUrl = partsListElement[i + 1]
          .querySelectorAll(_partsDetailUrlSelector)[0]
          .attributes['href'];
      final price =
          partsListElement[i + 1].querySelectorAll(_partsPriceSelector)[0].text;
      final ranked =
          partsListElement[i + 1].querySelectorAll(_patsRankedSelector)[0].text;

      // レビュー、評価数はセレクターでうまくパースできなかった為、改行ごとに区切って6つ目の要素を取得する
      // evaluate は 取得時 "4.95(15件)" という形式なので、"件"を除く
      var evaluation = '';
      var strStar = '';

      // 4つ目の要素に入っている場合もあったので、分岐して対応
      final evas = partsListElement[i + 1].text.split('\n');
      if (evas[5].contains('件')) {
        evaluation = evas[5].replaceAll('件', '');
      } else {
        final evaluations = evas[3].split('位');
        evaluation = evaluations[evaluations.length - 1].replaceAll('件', '');
      }
      strStar = evaluation.split('(')[0];

      int? star;
      if (strStar != '—') {
        // "4.95" -> "49" に変換
        if (double.tryParse(strStar) != null) {
          final doubleStar = double.parse(strStar);
          star = doubleStar * 100 ~/ 10;
        }
      }
      final partsId = detailUrl!.split('item/').last.split('/').first;
      partsList.add(
        PcParts(
          id: partsId,
          maker: maker,
          isNew: isNew,
          title: title,
          star: star,
          evaluation: evaluation,
          price: Price(price),
          ranked: ranked,
          image: imageUrl,
          detailUrl: detailUrl,
          category: category,
        ),
      );
    }
    return partsList;
  }
}
