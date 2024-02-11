import '../model/category_search_parameter.dart';
import '../model/custom.dart';
import '../model/parts_category.dart';
import '../model/recommend_parameter.dart';

class ParameterRecommender {
  ParameterRecommender(this.custom, this.selectingCategory, this.params) {
    recommendedParameters = recommend();
  }
  late final Custom custom;
  late final PartsCategory selectingCategory;
  late final CategorySearchParameter params;

  List<RecommendParameter> recommendedParameters = [];

  List<RecommendParameter> recommend() {
    var recommendedParameter = <RecommendParameter>[];

    switch (selectingCategory) {
      case PartsCategory.cpu:
        recommendedParameter = recommendParamsForCpu();
      case PartsCategory.cpuCooler:
        recommendedParameter = recommendParamsForCpuCooler();
      case PartsCategory.memory:
        recommendedParameter = recommendParamsForMemory();
      case PartsCategory.motherboard:
        recommendedParameter = recommendParamsForMotherBoard();
      case PartsCategory.graphicsCard:
        // TODO(kai): Handle this case.
        break;
      case PartsCategory.ssd:
        // TODO(kai): Handle this case.
        break;
      case PartsCategory.pcCase:
        // TODO(kai): Handle this case.
        break;
      case PartsCategory.powerUnit:
        // TODO(kai): Handle this case.
        break;
      case PartsCategory.caseFan:
        // TODO(kai): Handle this case.
        break;
    }
    return recommendedParameter;
  }

  String? _extractSpec(Map<String, String?> specs, String param) {
    String? specInfo;
    specs.forEach((key, value) {
      if (key.contains(param)) {
        specInfo = value;
      }
    });
    return specInfo;
  }

  int? getParamIndex(String paramSectionName, String paramName) {
    var specIndex = 0;
    var isComplete = false;
    final p = params.alignParameters();
    for (final para in p) {
      for (final par in para.entries) {
        specIndex = 0;
        if (par.key.contains(paramSectionName)) {
          for (final element in par.value) {
            if (element.name.contains(paramName)) {
              isComplete = true;
              break;
            }
            specIndex++;
          }
        }
        if (isComplete) {
          break;
        }
      }
      if (isComplete) {
        break;
      }
    }
    if (isComplete) {
      return specIndex;
    } else {
      return null;
    }
  }

  List<RecommendParameter> recommendParamsForCpu() {
    if (custom.get(PartsCategory.motherboard) == null) {
      return [];
    }

    // マザーボードのソケット形状を取得
    final motherBoard = custom.get(PartsCategory.motherboard)!;
    final rawSocket = _extractSpec(motherBoard.specs!, 'CPUソケット');
    if (rawSocket == null) {
      return [];
    }

    final socket = rawSocket.replaceAll('Socket', '');

    // CPUのパラメータに選択中のマザーボードのソケット形状があるか確認
    // ある場合は、そのソケット形状のインデックスを返す
    final specIndex = getParamIndex('ソケット形状', socket);
    if (specIndex != null) {
      return [
        // "ソケット形状"は3番目のパラメータなので、3を指定
        RecommendParameter(PartsCategory.motherboard, 3, socket, specIndex),
      ];
    }
    return [];
  }

  List<RecommendParameter> recommendParamsForCpuCooler() {
    if (custom.get(PartsCategory.motherboard) == null) {
      return [];
    }

    // マザーボードのソケット形状を取得
    final motherBoard = custom.get(PartsCategory.motherboard)!;
    final rawSocket = _extractSpec(motherBoard.specs!, 'CPUソケット');
    if (rawSocket == null) {
      return [];
    }
    var isIntel = false;
    var socket = '';
    if (rawSocket.contains('LGA')) {
      isIntel = true;
      socket = rawSocket.replaceAll('LGA', '');
    } else {
      socket = rawSocket.replaceAll('Socket', '');
    }

    // CPUクーラーのパラメータに、選択中のCPUのソケット形状があるか確認
    int? specIndex;
    if (isIntel) {
      specIndex = getParamIndex('intelソケット', socket);
    } else {
      specIndex = getParamIndex('AMDソケット', socket);
    }
    if (specIndex != null) {
      return [
        // intelソケットなら1番目のパラメータ、AMDソケットなら2番目のパラメータ
        RecommendParameter(
          PartsCategory.cpuCooler,
          isIntel ? 1 : 2,
          socket,
          specIndex,
        ),
      ];
    }
    return [];
  }

  List<RecommendParameter> recommendParamsForMemory() {
    if (custom.get(PartsCategory.motherboard) == null) {
      return [];
    }

    // マザーボードのメモリタイプを取得
    final motherBoard = custom.get(PartsCategory.motherboard)!;
    final rawMemoryType = _extractSpec(motherBoard.specs!, '詳細メモリタイプ');
    if (rawMemoryType == null) {
      return [];
    }
    // メモリインターフェース(DIMMなど)とメモリタイプ(DDR4など)に分割
    final memoryInterface = rawMemoryType.split(' ')[0];
    final memoryType = rawMemoryType.split(' ')[1];

    // メモリのパラメータに、選択中のマザーボードのメモリインターフェースとメモリタイプがあるか確認
    final memoryInterfaceIndex = getParamIndex('インターフェース', memoryInterface);
    final memoryTypeIndex = getParamIndex('規格', memoryType);

    final recs = <RecommendParameter>[];
    if (memoryInterfaceIndex != null) {
      recs.add(
        RecommendParameter(
          PartsCategory.memory,
          1,
          memoryInterface,
          memoryInterfaceIndex,
        ),
      );
    }
    if (memoryTypeIndex != null) {
      recs.add(
        RecommendParameter(
          PartsCategory.memory,
          2,
          memoryType,
          memoryTypeIndex,
        ),
      );
    }
    return recs;
  }

  List<RecommendParameter> recommendParamsForMotherBoard() {
    if (custom.get(PartsCategory.cpu) == null &&
        custom.get(PartsCategory.memory) == null) {
      return [];
    }

    final recs = <RecommendParameter>[];

    if (custom.get(PartsCategory.cpu) != null) {
      // CPUのソケット形状を取得
      final cpu = custom.get(PartsCategory.cpu)!;
      final rawSocket = _extractSpec(cpu.specs!, 'ソケット形状');
      if (rawSocket != null) {
        var isIntel = false;
        var socket = '';
        if (rawSocket.contains('LGA')) {
          isIntel = true;
          socket = rawSocket.replaceAll('LGA', '').trim();
        } else {
          socket = rawSocket.replaceAll('Socket', '').trim();
        }
        if (isIntel && getParamIndex('CPUソケット(intel)', socket) != null) {
          recs.add(
            RecommendParameter(
              PartsCategory.motherboard,
              0,
              socket,
              getParamIndex('CPUソケット(intel)', socket)!,
            ),
          );
        }

        if (!isIntel && getParamIndex('CPUソケット(AMD)', socket) != null) {
          recs.add(
            RecommendParameter(
              PartsCategory.motherboard,
              1,
              socket,
              getParamIndex('CPUソケット(AMD)', socket)!,
            ),
          );
        }
      }
    }

    if (custom.get(PartsCategory.memory) != null) {
      // メモリの規格を取得
      final memory = custom.get(PartsCategory.memory)!;
      final rawMemoryType = _extractSpec(memory.specs!, 'メモリ規格');
      if (rawMemoryType != null) {
        // メモリタイプ(DDR4など)に分割
        final memoryType = rawMemoryType.split(' ')[0];

        // マザーボードのパラメータに、選択中のメモリのメモリインターフェースとメモリタイプがあるか確認
        final memoryTypeIndex = getParamIndex('メモリタイプ', memoryType);

        if (memoryTypeIndex != null) {
          recs.add(
            RecommendParameter(
              PartsCategory.motherboard,
              3,
              rawMemoryType,
              memoryTypeIndex,
            ),
          );
        }
      }
    }
    return recs;
  }
}
