import 'package:html/dom.dart';

import '../../model/category_search_parameter.dart';
import '../../model/search_parameters/power_unit_search_parameter.dart';
import '../document_repository.dart';

class PowerUnitSearchParameterParser {
  PowerUnitSearchParameterParser._();
  static const String standardPage =
      'https://kakaku.com/pc/power-supply/itemlist.aspx';
  static const String _parameterSelector = '#menu > div.searchspec > div';

  late Document _document;
  late PowerUnitSearchParameter powerUnitSearchParameter;

  static Future<PowerUnitSearchParameterParser> create() async {
    final self = PowerUnitSearchParameterParser._()
      .._document = await DocumentRepository(standardPage).fetchDocument();
    final supportTypes = self._parseSupportTypes()!;
    final powerSupplyCapacity = self._parsePowerSupplyCapacity()!;
    self.powerUnitSearchParameter = PowerUnitSearchParameter(
      supportTypes,
      powerSupplyCapacity,
    );
    return self;
  }

  List<PartsSearchParameter>? _parseSupportTypes() {
    final supportTypeList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[5]
        .querySelectorAll('ul');

    for (final element in specListElement) {
      final supportTypeName = element.text.split('（')[0].replaceFirst('\n', '');
      final supportTypeParameterAtag = element.querySelectorAll('a');

      if (supportTypeParameterAtag.isNotEmpty) {
        final supportTypeParameter =
            supportTypeParameterAtag[0].attributes['href']!.split('?')[1];
        supportTypeList.add(
          PartsSearchParameter(
            supportTypeName,
            supportTypeParameter,
          ),
        );
      } else if (element.querySelectorAll('span').isNotEmpty) {
        final supportTypeParameter =
            element.querySelectorAll('span')[0].attributes['onclick']!;
        final split =
            supportTypeParameter.split("changeLocation('")[1].split("');")[0];
        supportTypeList.add(
          PartsSearchParameter(
            supportTypeName,
            split,
          ),
        );
      }
    }
    return supportTypeList;
  }

  List<PartsSearchParameter>? _parsePowerSupplyCapacity() {
    final powerSupplyCapacityList = <PartsSearchParameter>[];
    final specListElement = _document
        .querySelectorAll(_parameterSelector)[6]
        .querySelectorAll('ul');
    final powerSupplyCapacityListElement =
        specListElement[0].querySelectorAll('li');

    for (final element in powerSupplyCapacityListElement) {
      final powerSupplyCapacityName = element.text.split('（')[0];
      final powerSupplyCapacityParameterAtag = element.querySelectorAll('a');
      if (powerSupplyCapacityParameterAtag.isNotEmpty) {
        final powerSupplyCapacityParameter = powerSupplyCapacityParameterAtag[0]
            .attributes['href']!
            .split('?')[1];
        powerSupplyCapacityList.add(
          PartsSearchParameter(
            powerSupplyCapacityName,
            powerSupplyCapacityParameter,
          ),
        );
      } else if (element.querySelectorAll('span').isNotEmpty) {
        final powerSupplyCapacityParameter =
            element.querySelectorAll('span')[0].attributes['onclick']!;
        final split = powerSupplyCapacityParameter
            .split("changeLocation('")[1]
            .split("');")[0];
        powerSupplyCapacityList
            .add(PartsSearchParameter(powerSupplyCapacityName, split));
      }
    }
    return powerSupplyCapacityList;
  }
}
