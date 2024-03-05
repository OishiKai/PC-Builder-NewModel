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
          '''CREATE TABLE ${CustomTableField.tableName} (
        ${CustomTableField.id} TEXT PRIMARY KEY,
        ${CustomTableField.name} TEXT NOT NULL,
        ${CustomTableField.price} TEXT NOT NULL,
        ${CustomTableField.date} TEXT NOT NULL
        )''',
        )
        // カスタムとパーツの関係テーブル
        ..execute(
          '''CREATE TABLE ${CustomPartsRelationTableField.tableName} (
        ${CustomPartsRelationTableField.customId} TEXT PRIMARY KEY,
        ${CustomPartsRelationTableField.partsId} TEXT PRIMARY KEY)''',
        )
        // パーツテーブル
        ..execute(
          '''CREATE TABLE ${PcPartsTableField.tableName} (
        ${PcPartsTableField.id} TEXT,
        ${PcPartsTableField.maker} TEXT NOT NULL,
        ${PcPartsTableField.isNew} INTEGER NOT NULL,
        ${PcPartsTableField.title} TEXT NOT NULL,
        ${PcPartsTableField.star} INTEGER,
        ${PcPartsTableField.evaluation} TEXT,
        ${PcPartsTableField.price} TEXT NOT NULL,
        ${PcPartsTableField.ranked} TEXT NOT NULL,
        ${PcPartsTableField.image} TEXT NOT NULL,
        ${PcPartsTableField.detailUrl} TEXT NOT NULL,
        PRIMARY KEY (${PcPartsTableField.id}),
        FOREIGN KEY (${PcPartsTableField.id}) REFERENCES ${CustomPartsRelationTableField.tableName}(${CustomPartsRelationTableField.partsId}) ON DELETE CASCADE)''',
        )
        // 店情報テーブル
        ..execute(
          '''CREATE TABLE ${PartsShopsTableField.tableName} (
        ${PartsShopsTableField.id} INTEGER,
        ${PartsShopsTableField.partsId} INTEGER,
        ${PartsShopsTableField.rank} TEXT NOT NULL,
        ${PartsShopsTableField.price} INTEGER NOT NULL,
        ${PartsShopsTableField.bestPriceDiff} TEXT NOT NULL,
        ${PartsShopsTableField.name} TEXT,
        ${PartsShopsTableField.pageUrl} TEXT NOT NULL,
        PRIMARY KEY (${PartsShopsTableField.id}, ${PartsShopsTableField.partsId}),
        FOREIGN KEY (${PartsShopsTableField.partsId}) REFERENCES ${PcPartsTableField.tableName}(${PcPartsTableField.id}) ON DELETE CASCADE)''',
        )
        // スペック情報テーブル
        ..execute(
          '''CREATE TABLE ${PartsSpecsTableField.tableName} (
        ${PartsSpecsTableField.id} INTEGER,
        ${PartsSpecsTableField.partsId} INTEGER,
        ${PartsSpecsTableField.specName} TEXT NOT NULL,
        ${PartsSpecsTableField.specValue} TEXT,
        PRIMARY KEY (${PartsSpecsTableField.id}, ${PartsSpecsTableField.partsId}),
        FOREIGN KEY (${PartsSpecsTableField.partsId}) REFERENCES ${PcPartsTableField.tableName}(${PcPartsTableField.id}) ON DELETE CASCADE)''',
        )
        // 画像テーブル
        ..execute(
          '''CREATE TABLE ${FullScaleImagesTableField.tableName} (
        ${FullScaleImagesTableField.id} INTEGER,
        ${FullScaleImagesTableField.partsId} INTEGER,
        ${FullScaleImagesTableField.imageUrl} TEXT NOT NULL,
        PRIMARY KEY (${FullScaleImagesTableField.id}, ${FullScaleImagesTableField.partsId}),
        FOREIGN KEY (${FullScaleImagesTableField.partsId}) REFERENCES ${PcPartsTableField.tableName}(${PcPartsTableField.id}) ON DELETE CASCADE)''',
        );
    },
    version: 1,
  );
}
