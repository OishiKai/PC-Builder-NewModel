enum PartsCategory {
  cpu('CPU', 'CPU', 'cpu'),
  cpuCooler('CPUクーラー', 'CPUクーラー', 'cpu-cooler'),
  memory('メモリー', 'メモリ', 'pc-memory'),
  motherboard('マザーボード', 'マザーボード', 'motherboard'),
  graphicsCard('グラフィックボード・ビデオカード', 'グラフィックボード', 'videocard'),
  ssd('SSD', 'SSD', 'ssd'),
  pcCase('PCケース', 'ケース', 'pc-case'),
  powerUnit('電源ユニット', '電源', 'power-supply'),
  caseFan('ケースファン', 'ケースファン', 'case-fan');

  const PartsCategory(
    this.categoryName,
    this.categoryShortName,
    this.categoryParameter,
  );

  final String categoryName;
  final String categoryShortName;
  final String categoryParameter;

  String basePartsListUrl() {
    return 'https://kakaku.com/pc/$categoryParameter/itemlist.aspx';
  }

  static PartsCategory fromCategoryParameter(String categoryParameter) {
    switch (categoryParameter) {
      case 'cpu':
        return PartsCategory.cpu;
      case 'cpu-cooler':
        return PartsCategory.cpuCooler;
      case 'pc-memory':
        return PartsCategory.memory;
      case 'motherboard':
        return PartsCategory.motherboard;
      case 'videocard':
        return PartsCategory.graphicsCard;
      case 'ssd':
        return PartsCategory.ssd;
      case 'pc-case':
        return PartsCategory.pcCase;
      case 'power-supply':
        return PartsCategory.powerUnit;
      case 'case-fan':
        return PartsCategory.caseFan;
      default:
        throw Exception(
          '$categoryParameter is not found.',
        );
    }
  }
}
