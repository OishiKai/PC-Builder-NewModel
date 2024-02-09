import 'package:collection/collection.dart';

import '../model/parts_category.dart';
import '../model/parts_compatibility.dart';
import '../model/pc_parts.dart';

class CompatibilityAnalyzer {
  CompatibilityAnalyzer(this.parts);
  final List<PcParts> parts;

  String? _pickupSpec(Map<String, String?> specs, String key) {
    String? specInfo;
    specs.forEach((k, v) {
      if (k.contains(key)) {
        specInfo = v;
      }
    });
    return specInfo;
  }

  PartsCompatibility? analyzeCpuAndMotherBoard() {
    final cpu = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.cpu,
    );
    final motherBoard = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.motherboard,
    );
    if (cpu == null || motherBoard == null) {
      return null;
    }

    // ソケット形状の比較
    var cpuSocket = _pickupSpec(cpu.specs!, 'ソケット形状');
    var motherBoardSocket = _pickupSpec(motherBoard.specs!, 'CPUソケット');

    bool? isCompatibleSockets;
    if (cpuSocket != null && motherBoardSocket != null) {
      cpuSocket = cpuSocket.replaceAll(' ', '');
      motherBoardSocket = motherBoardSocket.replaceAll(' ', '');
      isCompatibleSockets = cpuSocket == motherBoardSocket;
    }

    // チップセットの比較 未実装
    bool? isCompatibleChipsets;

    return PartsCompatibility(
      [PartsCategory.cpu, PartsCategory.motherboard],
      [cpu.image, motherBoard.image],
      isCompatible: {
        'ソケット形状': isCompatibleSockets,
        'チップセット': isCompatibleChipsets,
      },
    );
  }

  PartsCompatibility? analyzeCpuCoolerAndMotherBoard() {
    final cpuCooler = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.cpuCooler,
    );
    final motherBoard = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.motherboard,
    );
    if (cpuCooler == null || motherBoard == null) {
      return null;
    }
    // ソケット形状の比較
    final cpuCoolerIntelSocket = _pickupSpec(cpuCooler.specs!, 'Intel対応ソケット');
    final cpuCoolerAmdSocket = _pickupSpec(cpuCooler.specs!, 'AMD対応ソケット');
    final motherBoardSocket = _pickupSpec(motherBoard.specs!, 'CPUソケット');

    final nullCase = PartsCompatibility(
      [PartsCategory.cpuCooler, PartsCategory.motherboard],
      [cpuCooler.image, motherBoard.image],
      isCompatible: {
        'ソケット形状': null,
      },
    );

    var isCompatible = false;

    if (motherBoardSocket == null) {
      // マザボのソケット形状が不明な場合は判定不可
      return nullCase;
    }

    // マザボがインテル対応の場合
    if (motherBoardSocket.contains('LGA')) {
      if (cpuCoolerIntelSocket == null) {
        return nullCase;
      }
      final motherSocketScrape = motherBoardSocket.replaceAll('LGA', '');

      if (cpuCoolerIntelSocket.contains(motherSocketScrape)) {
        isCompatible = true;
      }
    }

    // マザボがAMD対応の場合
    if (motherBoardSocket.contains('Socket')) {
      if (cpuCoolerAmdSocket == null) {
        return nullCase;
      }

      final motherSocketScrape = motherBoardSocket.replaceAll('Socket', '');
      if (cpuCoolerAmdSocket.contains(motherSocketScrape)) {
        isCompatible = true;
      }
    }

    return PartsCompatibility(
      [PartsCategory.cpuCooler, PartsCategory.motherboard],
      [cpuCooler.image, motherBoard.image],
      isCompatible: {
        'ソケット形状': isCompatible,
      },
    );
  }

  PartsCompatibility? analyzeMemoryAndMotherBoard() {
    final memory = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.memory,
    );
    final motherBoard = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.motherboard,
    );
    if (memory == null || motherBoard == null) {
      return null;
    }

    // メモリの規格の比較
    var memoryStandard = _pickupSpec(memory.specs!, 'メモリ規格');
    final motherBoardStandard = _pickupSpec(motherBoard.specs!, '詳細メモリタイプ');

    bool? isCompatibleStandards;

    if (memoryStandard != null && motherBoardStandard != null) {
      // "DDR4 SDRAM" -> "DDR4" に変換
      memoryStandard = memoryStandard.split(' ')[0];
      if (motherBoardStandard.contains(memoryStandard)) {
        isCompatibleStandards = true;
      } else {
        isCompatibleStandards = false;
      }
    }

    // メモリの枚数の比較
    final numberOfMemory = _pickupSpec(memory.specs!, '枚数');
    final numberOfMemorySlots = _pickupSpec(motherBoard.specs!, 'メモリスロット数');

    bool? isCompatibleSlots;

    if (numberOfMemory != null && numberOfMemorySlots != null) {
      // メモリ枚数、メモリスロット数を数値に変換
      final numberOfMemoryInt = int.tryParse(
        numberOfMemory.replaceAll('枚', ''),
      );
      final numberOfMemorySlotsInt = int.tryParse(numberOfMemorySlots);

      if (numberOfMemoryInt != null && numberOfMemorySlotsInt != null) {
        // メモリ枚数がメモリスロット数以下であれば互換性あり
        if (numberOfMemoryInt <= numberOfMemorySlotsInt) {
          isCompatibleSlots = true;
        } else {
          isCompatibleSlots = false;
        }
      }
    }

    return PartsCompatibility(
      [PartsCategory.memory, PartsCategory.motherboard],
      [memory.image, motherBoard.image],
      isCompatible: {
        '規格': isCompatibleStandards,
        'メモリスロット数': isCompatibleSlots,
      },
    );
  }

  PartsCompatibility? analyzeMotherBoardAndSsd() {
    final motherBoard = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.motherboard,
    );
    final ssd = parts.firstWhereOrNull(
      (part) => part.category == PartsCategory.ssd,
    );
    if (motherBoard == null || ssd == null) {
      return null;
    }
    var ssdStandardSize = _pickupSpec(ssd.specs!, '規格サイズ');

    // サイズ不明
    if (ssdStandardSize == null) {
      return PartsCompatibility(
        [PartsCategory.motherboard, PartsCategory.ssd],
        [motherBoard.image, ssd.image],
        isCompatible: {
          '互換性': null,
        },
      );
    }

    // M.2の場合
    if (ssdStandardSize.contains('M.2')) {
      final motherBoardM2Sockets = _pickupSpec(motherBoard.specs!, 'M.2ソケット数');
      final motherBoardM2Size = _pickupSpec(motherBoard.specs!, 'M.2サイズ');

      // M.2ソケット数の情報があるなら対応していると判定
      final isCompatibleSockets = motherBoardM2Sockets != null;
      bool? isCompatibleSize;

      // "M.2 (Type0000)" -> "0000" に変換
      ssdStandardSize =
          ssdStandardSize.trim().split('M.2 (Type')[1].replaceAll(')', '');
      if (motherBoardM2Size != null) {
        // M.2サイズ情報があるなら一致しているか判定
        isCompatibleSize = motherBoardM2Size.contains(ssdStandardSize);
      }

      return PartsCompatibility(
        [PartsCategory.motherboard, PartsCategory.ssd],
        [motherBoard.image, ssd.image],
        isCompatible: {
          'ソケット数': isCompatibleSockets,
          'サイズ': isCompatibleSize,
        },
      );
    }

    // 2.5インチの場合
    if (ssdStandardSize.contains('2.5インチ')) {
      final motherBoardSataPorts = _pickupSpec(motherBoard.specs!, 'SATA');

      return PartsCompatibility(
        [PartsCategory.motherboard, PartsCategory.ssd],
        [motherBoard.image, ssd.image],
        isCompatible: {
          // SATAの情報があるなら対応していると判定
          'SATAポート数': motherBoardSataPorts != null,
        },
      );
    }

    // M.2, 2.5インチ以外の場合
    return PartsCompatibility(
      [PartsCategory.motherboard, PartsCategory.ssd],
      [motherBoard.image, ssd.image],
      isCompatible: {
        '互換性': null,
      },
    );
  }
}
