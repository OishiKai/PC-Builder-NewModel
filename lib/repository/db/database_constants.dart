enum CustomTableField {
  tableName('custom'),
  id('id'),
  name('name'),
  price('price'),
  date('date');

  const CustomTableField(this.value);
  final String value;
}

enum CustomPartsRelationTableField {
  tableName('custom_parts_relation'),
  customId('custom_id'),
  partsId('parts_id');

  const CustomPartsRelationTableField(this.value);
  final String value;
}

enum PcPartsTableField {
  tableName('pc_parts'),
  id('id'),
  category('category'),
  maker('maker'),
  isNew('is_new'),
  title('title'),
  star('star'),
  evaluation('evaluation'),
  price('price'),
  ranked('ranked'),
  image('image'),
  detailUrl('detail_url');

  const PcPartsTableField(this.value);
  final String value;
}

enum PartsShopsTableField {
  tableName('parts_shops'),
  id('id'),
  partsId('parts_id'),
  rank('rank'),
  price('price'),
  bestPriceDiff('best_price_diff'),
  name('name'),
  pageUrl('page_url');

  const PartsShopsTableField(this.value);
  final String value;
}

enum PartsSpecsTableField {
  tableName('parts_specs'),
  id('id'),
  partsId('parts_id'),
  specName('spec_name'),
  specValue('spec_value');

  const PartsSpecsTableField(this.value);
  final String value;
}

enum FullScaleImagesTableField {
  tableName('full_scale_images'),
  id('id'),
  partsId('parts_id'),
  imageUrl('image_url');

  const FullScaleImagesTableField(this.value);
  final String value;
}
