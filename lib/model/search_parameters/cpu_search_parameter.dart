import '../category_search_parameter.dart';

class CpuSearchParameter extends CategorySearchParameter {
  CpuSearchParameter(this.makers, this.processors, this.series, this.sockets);
  final List<PartsSearchParameter> makers;
  final List<PartsSearchParameter> processors;
  final List<PartsSearchParameter> series;
  final List<PartsSearchParameter> sockets;

  @override
  CpuSearchParameter clearSelectedParameter() {
    final clearMaker = <PartsSearchParameter>[];
    for (final element in makers) {
      element.isSelect = false;
      clearMaker.add(element);
    }
    final clearProcessor = <PartsSearchParameter>[];
    for (final element in processors) {
      element.isSelect = false;
      clearProcessor.add(element);
    }
    final clearSeries = <PartsSearchParameter>[];
    for (final element in series) {
      element.isSelect = false;
      clearSeries.add(element);
    }
    final clearSockets = <PartsSearchParameter>[];
    for (final element in sockets) {
      element.isSelect = false;
      clearSockets.add(element);
    }

    return CpuSearchParameter(
      clearMaker,
      clearProcessor,
      clearSeries,
      clearSockets,
    );
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in makers) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in processors) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in series) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in sockets) {
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
    for (final element in processors) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in series) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in sockets) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'メーカー': makers},
      {'プロセッサ': processors},
      {'世代': series},
      {'ソケット形状': sockets},
    ];
  }

  @override
  CpuSearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case 'メーカー':
        final toggleMaker = makers;
        toggleMaker[index].isSelect = !makers[index].isSelect;
        return CpuSearchParameter(toggleMaker, processors, series, sockets);
      case 'プロセッサ':
        final toggleProcessors = processors;
        toggleProcessors[index].isSelect = !processors[index].isSelect;
        return CpuSearchParameter(makers, toggleProcessors, series, sockets);
      case '世代':
        final toggleSeries = series;
        toggleSeries[index].isSelect = !series[index].isSelect;
        return CpuSearchParameter(makers, processors, toggleSeries, sockets);
      case 'ソケット形状':
        final toggleSockets = sockets;
        toggleSockets[index].isSelect = !sockets[index].isSelect;
        return CpuSearchParameter(makers, processors, series, toggleSockets);
      default:
        return CpuSearchParameter(makers, processors, series, sockets);
    }
  }
}
