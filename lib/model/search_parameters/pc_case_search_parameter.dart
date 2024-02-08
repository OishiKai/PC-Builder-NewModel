import '../category_search_parameter.dart';

class PcCaseSearchParameter extends CategorySearchParameter {
  PcCaseSearchParameter(
    this.supportMotherBoards,
    this.supportGraphicsCards,
    this.colors,
  );

  final List<PartsSearchParameter> supportMotherBoards;
  final List<PartsSearchParameter> supportGraphicsCards;
  final List<PartsSearchParameter> colors;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'対応マザーボード': supportMotherBoards},
      {'対応グラフィックボード': supportGraphicsCards},
      {'カラー': colors},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearSupportMotherBoards = <PartsSearchParameter>[];
    for (final element in supportMotherBoards) {
      element.isSelect = false;
      clearSupportMotherBoards.add(element);
    }
    final clearSupportGraphicsCards = <PartsSearchParameter>[];
    for (final element in supportGraphicsCards) {
      element.isSelect = false;
      clearSupportGraphicsCards.add(element);
    }
    final clearColors = <PartsSearchParameter>[];
    for (final element in colors) {
      element.isSelect = false;
      clearColors.add(element);
    }

    return PcCaseSearchParameter(
        clearSupportMotherBoards, clearSupportGraphicsCards, clearColors);
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in supportMotherBoards) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in supportGraphicsCards) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in colors) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in supportMotherBoards) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in supportGraphicsCards) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in colors) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case '対応マザーボード':
        final toggleSupportMotherBoards = supportMotherBoards;
        toggleSupportMotherBoards[index].isSelect =
            !toggleSupportMotherBoards[index].isSelect;
        return PcCaseSearchParameter(
          toggleSupportMotherBoards,
          supportGraphicsCards,
          colors,
        );

      case '対応グラフィックボード':
        final toggleSupportGraphicsCards = supportGraphicsCards;
        toggleSupportGraphicsCards[index].isSelect =
            !toggleSupportGraphicsCards[index].isSelect;
        return PcCaseSearchParameter(
          supportMotherBoards,
          toggleSupportGraphicsCards,
          colors,
        );

      case 'カラー':
        final toggleColors = colors;
        toggleColors[index].isSelect = !toggleColors[index].isSelect;
        return PcCaseSearchParameter(
          supportMotherBoards,
          supportGraphicsCards,
          toggleColors,
        );

      default:
        return this;
    }
  }
}
