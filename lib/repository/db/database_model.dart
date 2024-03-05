import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';

class DatabaseModel {
  DatabaseModel._();
  static final Future<Database> database = openDatabase(
    join(getDatabasesPath().toString(), 'custom_pc_database_v2.db'),
    // マイグレーション
    onCreate: (db, version) {
      db
        ..execute('PRAGMA foreign_keys = ON')
        // カスタムテーブル
        ..execute(
          '''CREATE TABLE ${CustomTableField.tableName.value} (
        ${CustomTableField.id.value} TEXT PRIMARY KEY,
        ${CustomTableField.name.value} TEXT NOT NULL,
        ${CustomTableField.price.value} TEXT NOT NULL,
        ${CustomTableField.date.value} TEXT NOT NULL
        )''',
        )
        // カスタムとパーツの関係テーブル
        ..execute(
          '''CREATE TABLE ${CustomPartsRelationTableField.tableName.value} (
        ${CustomPartsRelationTableField.customId.value} TEXT PRIMARY KEY,
        ${CustomPartsRelationTableField.partsId.value} TEXT PRIMARY KEY)''',
        )
        // パーツテーブル
        ..execute(
          '''CREATE TABLE ${PcPartsTableField.tableName.value} (
        ${PcPartsTableField.id.value} TEXT,
        ${PcPartsTableField.category.value} TEXT NOT NULL,
        ${PcPartsTableField.maker.value} TEXT NOT NULL,
        ${PcPartsTableField.isNew.value} INTEGER NOT NULL,
        ${PcPartsTableField.title.value} TEXT NOT NULL,
        ${PcPartsTableField.star.value} INTEGER,
        ${PcPartsTableField.evaluation.value} TEXT,
        ${PcPartsTableField.price.value} TEXT NOT NULL,
        ${PcPartsTableField.ranked.value} TEXT NOT NULL,
        ${PcPartsTableField.image.value} TEXT NOT NULL,
        ${PcPartsTableField.detailUrl.value} TEXT NOT NULL,
        PRIMARY KEY (${PcPartsTableField.id.value}),
        FOREIGN KEY (${PcPartsTableField.id.value}) REFERENCES ${CustomPartsRelationTableField.tableName.value}(${CustomPartsRelationTableField.partsId.value}) ON DELETE CASCADE)''',
        )
        // 店情報テーブル
        ..execute(
          '''CREATE TABLE ${PartsShopsTableField.tableName.value} (
        ${PartsShopsTableField.id.value} INTEGER,
        ${PartsShopsTableField.partsId.value} TEXT,
        ${PartsShopsTableField.rank.value} TEXT NOT NULL,
        ${PartsShopsTableField.price.value} INTEGER NOT NULL,
        ${PartsShopsTableField.bestPriceDiff.value} TEXT NOT NULL,
        ${PartsShopsTableField.name.value} TEXT,
        ${PartsShopsTableField.pageUrl.value} TEXT NOT NULL,
        PRIMARY KEY (${PartsShopsTableField.id.value}, ${PartsShopsTableField.partsId.value}),
        FOREIGN KEY (${PartsShopsTableField.partsId.value}) REFERENCES ${PcPartsTableField.tableName.value}(${PcPartsTableField.id.value}) ON DELETE CASCADE)''',
        )
        // スペック情報テーブル
        ..execute(
          '''CREATE TABLE ${PartsSpecsTableField.tableName.value} (
        ${PartsSpecsTableField.id.value} INTEGER,
        ${PartsSpecsTableField.partsId.value} TEXT,
        ${PartsSpecsTableField.specName.value} TEXT NOT NULL,
        ${PartsSpecsTableField.specValue.value} TEXT,
        PRIMARY KEY (${PartsSpecsTableField.id.value}, ${PartsSpecsTableField.partsId.value}),
        FOREIGN KEY (${PartsSpecsTableField.partsId.value}) REFERENCES ${PcPartsTableField.tableName.value}(${PcPartsTableField.id.value}) ON DELETE CASCADE)''',
        )
        // 画像テーブル
        ..execute(
          '''CREATE TABLE ${FullScaleImagesTableField.tableName.value} (
        ${FullScaleImagesTableField.id.value} INTEGER,
        ${FullScaleImagesTableField.partsId.value} TEXT,
        ${FullScaleImagesTableField.imageUrl.value} TEXT NOT NULL,
        PRIMARY KEY (${FullScaleImagesTableField.id.value}, ${FullScaleImagesTableField.partsId.value}),
        FOREIGN KEY (${FullScaleImagesTableField.partsId.value}) REFERENCES ${PcPartsTableField.tableName.value}(${PcPartsTableField.id.value}) ON DELETE CASCADE)''',
        );
    },
    version: 1,
  );
}
