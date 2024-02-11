import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/parts_category.dart';
import '../model/parts_compatibility.dart';
import '../model/pc_parts.dart';
import '../repository/parse_pc_parts/compatibility_analyze_repository.dart';
import '../repository/price.dart';

part 'custom.freezed.dart';

@freezed
abstract class Custom with _$Custom {
  const factory Custom({
    String? id,
    // Custom名
    String? name,
    // 総額
    String? totalPrice,
    // 各パーツ
    List<PcParts>? parts,

    // 保存日
    String? date,

    // 互換性のリスト
    List<PartsCompatibility>? compatibilities,
  }) = _Custom;
}

extension CustomExtension on Custom {
  int calculateTotalPrice() {
    if (parts == null) {
      return 0;
    }
    var totalPrice = 0;
    for (final p in parts!) {
      totalPrice += Price(p.price).intPrice;
    }
    return totalPrice;
  }

  Custom updateCompatibilities() {
    if (parts == null) {
      return this;
    }

    final comps = <PartsCompatibility>[];
    final analyzer = CompatibilityAnalyzeRepository(parts!);

    final compCpuAndMotherBoard = analyzer.analyzeCpuAndMotherBoard();
    if (compCpuAndMotherBoard != null) {
      comps.add(compCpuAndMotherBoard);
    }

    final compCpuCoolerAndMotherBoard =
        analyzer.analyzeCpuCoolerAndMotherBoard();
    if (compCpuCoolerAndMotherBoard != null) {
      comps.add(compCpuCoolerAndMotherBoard);
    }

    final compMemoryAndMotherBoard = analyzer.analyzeMemoryAndMotherBoard();
    if (compMemoryAndMotherBoard != null) {
      comps.add(compMemoryAndMotherBoard);
    }

    final compMotherBoardAndSsd = analyzer.analyzeMotherBoardAndSsd();
    if (compMotherBoardAndSsd != null) {
      comps.add(compMotherBoardAndSsd);
    }
    return copyWith(compatibilities: comps);
  }

  /// 保存済みCustom一覧サムネイル用の画像
  String mainPartsImage() {
    if (parts == null) {
      return '';
    }
    final mainParts = parts!.reduce(
      (a, b) => Price(a.price).intPrice > Price(b.price).intPrice ? a : b,
    );
    return mainParts.image;
  }

  PcParts? get(PartsCategory category) {
    if (parts == null) {
      return null;
    }
    return parts!.firstWhereOrNull((parts) => parts.category == category);
  }
}
