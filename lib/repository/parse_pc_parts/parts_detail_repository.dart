import 'package:custom_pc_new_model/model/pc_parts.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';

import '../../model/parts_shop.dart';
import '../document_repository.dart';

class PartsDetailRepository {
  PartsDetailRepository(this.pcParts);
  final PcParts pcParts;

  static const _fullScaleImageSelector =
      '#main > div.alignC > div > table > tbody > tr > td > a > img';
  static const _fullScaleFirstImageSelector =
      '#main > div.alignC > div > table > tbody > tr > td > img';

  // 店舗情報のリスト
  static const _partsShopListSelector = '#mainLeft > table > tbody > tr';

  // 店舗の価格ランキング
  static const _partsShopRankSelector = 'td:nth-child(1) > span';

  // 店舗の販売価格
  static const _partsShopPriceSelector =
      'td.p-priceTable_col.p-priceTable_col-priceBG > div > p.p-PTPrice_price';

  /*
  最安値と店舗の販売価格の差
  最安値で販売している場合は '(最安)'と取得される
   */
  static const _partsShopBestPriceDiffSelector =
      'td.p-priceTable_col.p-priceTable_col-priceBG > div > p.p-PTPrice_sub';

  // 店舗名
  static const _partsShopNameSelector =
      'td.p-priceTable_col.p-priceTable_col-shopInfo > div.p-PTShop >'
      ' div.p-PTShop_info > div > p.p-PTShopData_name > a';

  // 店舗の販売ページ
  static const _partsShopPageUrlSelector =
      'td.p-priceTable_col.p-priceTable_col-shopInfo >'
      ' div.p-PTShop > div.p-PTShop_btn > a';

  // パーツのスペックテーブル行
  static const _partsSpecLineSelector = '#mainLeft > table > tbody > tr';

  Future<PcParts> fetch(PcParts parts) async {
    final doc = await DocumentRepository(parts.detailUrl).fetchDocument();
    final fullScaleImages =
        (await _getFullScaleImageUrls(parts.detailUrl)) ?? [parts.image];
    final partsShops = _getPartsShops(doc);
    final specs = await _getSpecs(parts.detailUrl);

    return parts.copyWith(
      fullScaleImages: fullScaleImages,
      shops: partsShops,
      specs: specs,
    );
  }

  Future<List<String>?> _getFullScaleImageUrls(String detailUrl) async {
    final imageUrls = <String>[];
    final baseImageUrl =
        '${detailUrl.replaceFirst('?lid=pc_ksearch_kakakuitem', '')}images/';
    final multiImageUrl = '${baseImageUrl}page=ka_';
    var imageCount = 0;

    while (true) {
      //　1枚目だけURLが異なる為分岐
      if (imageCount == 0) {
        final firstImageDoc =
            await DocumentRepository(baseImageUrl).fetchDocument();
        var firstImage =
            firstImageDoc.querySelectorAll(_fullScaleFirstImageSelector);

        if (firstImage.isEmpty) {
          firstImage = firstImageDoc.querySelectorAll(_fullScaleImageSelector);
          if (firstImage.isEmpty) {
            return null;
          }
        }

        imageUrls.add(firstImage[0].attributes['src']!);
        imageCount += 1;
        continue;
      }

      final imageDoc =
          await DocumentRepository('$multiImageUrl$imageCount').fetchDocument();
      final image = imageDoc.querySelectorAll(_fullScaleImageSelector);
      imageCount += 1;

      if (image.isEmpty) {
        break;
      }
      imageUrls.add(image[0].attributes['src']!);
    }
    return imageUrls;
  }

  static List<PartsShop> _getPartsShops(Document doc) {
    final partsShopList = <PartsShop>[];
    final listElements = doc.querySelectorAll(_partsShopListSelector);
    // 販売店がない場合
    if (listElements.isEmpty) {
      return partsShopList;
    }

    /*
    販売店が1件以上ある場合、listElements.length は 店舗数+2 となる。
    先頭2つのノードが店舗情報ではない為、3つめのノードからパースを行う。
    また、販売店が11件以上ある場合は10件おきに2つの店舗情報ではないノードが入る為、adjustIndexでパース対象を調整する。
     */
    final numberOfNode = listElements.length;
    var parsedShopCount = 0;
    var adjustIndex = 2;
    while (true) {
      final shopNodeIndex = parsedShopCount + adjustIndex;

      // 販売店のランクがない場合がある為、空文字を入れる
      final rawRank =
          listElements[shopNodeIndex].querySelectorAll(_partsShopRankSelector);
      var rank = '';
      if (rawRank.isNotEmpty) {
        rank = rawRank[0].text;
      }

      final price = listElements[shopNodeIndex]
          .querySelectorAll(_partsShopPriceSelector)[0]
          .text;

      // 販売店の最安値との差がない場合、空文字を入れる
      final rawDiff = listElements[shopNodeIndex]
          .querySelectorAll(_partsShopBestPriceDiffSelector);
      var diff = '';
      if (rawDiff.isNotEmpty) {
        diff = rawDiff[0].text;
      }

      final shopName = listElements[shopNodeIndex]
          .querySelectorAll(_partsShopNameSelector)[0]
          .text;
      final shopPageUrl = listElements[shopNodeIndex]
          .querySelectorAll(_partsShopPageUrlSelector)[0]
          .attributes['href'];
      partsShopList.add(PartsShop(rank, price, diff, shopName, shopPageUrl!));
      parsedShopCount++;
      if (parsedShopCount + adjustIndex == numberOfNode) {
        break;
      }
      // 販売店10件おきに2つ、店舗情報ではないノードが入る為、indexを調整
      if (parsedShopCount % 10 == 0) {
        adjustIndex += 2;
      }
    }

    partsShopList.removeWhere((element) => element.shopName.contains(''));

    return partsShopList;
  }

  static Future<Map<String, String?>> _getSpecs(String url) async {
    final specMap = <String, String?>{};
    final tempUrl = url.replaceFirst('/?lid=pc_ksearch_kakakuitem', '');
    final specUrl = '${tempUrl}spec/';
    if (kDebugMode) {
      print(specUrl);
    }
    final doc = await DocumentRepository(specUrl).fetchDocument();
    final specElements = doc.querySelectorAll(_partsSpecLineSelector);
    final elementLength = specElements.length;

    /*
    該当ページのスペックが記載されているテーブルは分類行とスペック行の二種で構成されている。
    分類行は分類名のみ取得し、スペック行はカテゴリー名とスペック名のペアを2回取得する。
    分類はkeyのみでvalueはnull、カテゴリー名はあるがスペック名がない場合はvalueは空文字で表現。
    */
    var classLineCount = 0;
    var specLineCount = 0;
    while (true) {
      final next = classLineCount + specLineCount;
      if (specElements[next].querySelectorAll('td').isEmpty) {
        // 分類行
        final cls = specElements[next].text.replaceFirst('\n', '');
        specMap[cls] = null;
        classLineCount++;
        continue;
      }
      // カテゴリー+スペック行
      for (var i = 0; i < 2; i++) {
        final category = specElements[next].querySelectorAll('th')[i].text;
        final spec = specElements[next].querySelectorAll('td')[i].text;
        specMap[category] = spec;
      }
      specLineCount++;

      if (classLineCount + specLineCount == elementLength) {
        break;
      }
    }
    // specMap.forEach((key, value) {
    //   print('$key : $value');
    // });

    return specMap;
  }
}
