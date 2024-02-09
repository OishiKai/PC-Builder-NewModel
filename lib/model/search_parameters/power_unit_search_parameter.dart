import '../category_search_parameter.dart';

class PowerUnitSearchParameter extends CategorySearchParameter {
  PowerUnitSearchParameter(this.supportTypes, this.powerSupplyCapacities);
  final List<PartsSearchParameter> supportTypes;
  final List<PartsSearchParameter> powerSupplyCapacities;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'対応規格': supportTypes},
      {'電源容量': powerSupplyCapacities},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearSupportTypes = <PartsSearchParameter>[];
    for (final element in supportTypes) {
      element.isSelect = false;
      clearSupportTypes.add(element);
    }
    final clearPowerSupplyCapacities = <PartsSearchParameter>[];
    for (final element in powerSupplyCapacities) {
      element.isSelect = false;
      clearPowerSupplyCapacities.add(element);
    }

    return PowerUnitSearchParameter(
      clearSupportTypes,
      clearPowerSupplyCapacities,
    );
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in supportTypes) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in powerSupplyCapacities) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in supportTypes) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }

    for (final element in powerSupplyCapacities) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case '対応規格':
        final toggleSupportTypes = supportTypes;
        toggleSupportTypes[index].isSelect =
            !toggleSupportTypes[index].isSelect;
        return PowerUnitSearchParameter(
          toggleSupportTypes,
          powerSupplyCapacities,
        );

      case '電源容量':
        final togglePowerSupplyCapacities = powerSupplyCapacities;
        togglePowerSupplyCapacities[index].isSelect =
            !togglePowerSupplyCapacities[index].isSelect;
        return PowerUnitSearchParameter(
          supportTypes,
          togglePowerSupplyCapacities,
        );

      default:
        return this;
    }
  }
}
