import '../category_search_parameter.dart';

class MotherBoardSearchParameter extends CategorySearchParameter {
  MotherBoardSearchParameter(
    this.intelSockets,
    this.amdSockets,
    this.formFactors,
    this.memoryType,
  );

  final List<PartsSearchParameter> intelSockets;
  final List<PartsSearchParameter> amdSockets;
  final List<PartsSearchParameter> formFactors;
  final List<PartsSearchParameter> memoryType;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'CPUソケット(intel)': intelSockets},
      {'CPUソケット(AMD)': amdSockets},
      {'フォームファクタ': formFactors},
      {'メモリタイプ': memoryType},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearIntelSockets = <PartsSearchParameter>[];
    for (final element in intelSockets) {
      element.isSelect = false;
      clearIntelSockets.add(element);
    }
    final clearAmdSockets = <PartsSearchParameter>[];
    for (final element in amdSockets) {
      element.isSelect = false;
      clearAmdSockets.add(element);
    }
    final clearFormFactors = <PartsSearchParameter>[];
    for (final element in formFactors) {
      element.isSelect = false;
      clearFormFactors.add(element);
    }
    final clearMemoryType = <PartsSearchParameter>[];
    for (final element in memoryType) {
      element.isSelect = false;
      clearMemoryType.add(element);
    }

    return MotherBoardSearchParameter(
        clearIntelSockets, clearAmdSockets, clearFormFactors, clearMemoryType);
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in intelSockets) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in amdSockets) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in formFactors) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in memoryType) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in intelSockets) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in amdSockets) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in formFactors) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in memoryType) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case 'CPUソケット(intel)':
        final toggleIntelSockets = intelSockets;
        toggleIntelSockets[index].isSelect = !intelSockets[index].isSelect;
        return MotherBoardSearchParameter(
          toggleIntelSockets,
          amdSockets,
          formFactors,
          memoryType,
        );

      case 'CPUソケット(AMD)':
        final toggleAmdSockets = amdSockets;
        toggleAmdSockets[index].isSelect = !amdSockets[index].isSelect;
        return MotherBoardSearchParameter(
          intelSockets,
          toggleAmdSockets,
          formFactors,
          memoryType,
        );

      case 'フォームファクタ':
        final toggleFormFactors = formFactors;
        toggleFormFactors[index].isSelect = !formFactors[index].isSelect;
        return MotherBoardSearchParameter(
          intelSockets,
          amdSockets,
          toggleFormFactors,
          memoryType,
        );

      case 'メモリタイプ':
        final toggleMemoryType = memoryType;
        toggleMemoryType[index].isSelect = !memoryType[index].isSelect;
        return MotherBoardSearchParameter(
          intelSockets,
          amdSockets,
          formFactors,
          toggleMemoryType,
        );

      default:
        return this;
    }
  }
}
