// import 'package:custom_pc/domain/search_parameter_parser/cpu_cooler_search_parameter_repository.dart';

import '../category_search_parameter.dart';

class CpuCoolerSearchParameter extends CategorySearchParameter {
  CpuCoolerSearchParameter(
    this.makers,
    this.intelSockets,
    this.amdSockets,
    this.type,
  );
  final List<PartsSearchParameter> makers;
  final List<PartsSearchParameter> intelSockets;
  final List<PartsSearchParameter> amdSockets;
  final List<PartsSearchParameter> type;

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in makers) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
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
    for (final element in type) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in makers) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
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
    for (final element in type) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CpuCoolerSearchParameter clearSelectedParameter() {
    final clearMaker = <PartsSearchParameter>[];
    for (final element in makers) {
      element.isSelect = false;
      clearMaker.add(element);
    }
    final clearIntelSocket = <PartsSearchParameter>[];
    for (final element in intelSockets) {
      element.isSelect = false;
      clearIntelSocket.add(element);
    }
    final clearAmdSocket = <PartsSearchParameter>[];
    for (final element in amdSockets) {
      element.isSelect = false;
      clearAmdSocket.add(element);
    }
    final clearType = <PartsSearchParameter>[];
    for (final element in type) {
      element.isSelect = false;
      clearType.add(element);
    }

    return CpuCoolerSearchParameter(
      clearMaker,
      clearIntelSocket,
      clearAmdSocket,
      clearType,
    );
  }

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'メーカー': makers},
      {'intelソケット': intelSockets},
      {'AMDソケット': amdSockets},
      {'タイプ': type},
    ];
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case 'メーカー':
        final toggleMaker = makers;
        toggleMaker[index].isSelect = !makers[index].isSelect;
        return CpuCoolerSearchParameter(
          toggleMaker,
          intelSockets,
          amdSockets,
          type,
        );

      case 'intelソケット':
        final toggleIntelSockets = intelSockets;
        toggleIntelSockets[index].isSelect = !intelSockets[index].isSelect;
        return CpuCoolerSearchParameter(
          makers,
          toggleIntelSockets,
          amdSockets,
          type,
        );

      case 'AMDソケット':
        final toggleAmdSockets = amdSockets;
        toggleAmdSockets[index].isSelect = !amdSockets[index].isSelect;
        return CpuCoolerSearchParameter(
          makers,
          intelSockets,
          toggleAmdSockets,
          type,
        );

      case 'タイプ':
        final toggleType = type;
        toggleType[index].isSelect = !type[index].isSelect;
        return CpuCoolerSearchParameter(
          makers,
          intelSockets,
          amdSockets,
          toggleType,
        );
      default:
        return this;
    }
  }
}
