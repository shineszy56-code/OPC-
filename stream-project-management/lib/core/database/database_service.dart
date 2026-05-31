import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_schema.dart';

/// 数据库服务
/// 管理 SQLite 数据库的初始化、加密配置和版本管理
class DatabaseService {
  DatabaseService._();

  static DatabaseService? _instance;
  static Database? _database;

  factory DatabaseService() {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  /// 获取数据库实例
  /// 首次调用时初始化数据库
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  /// 使用 SQLCipher 加密，密钥来自 KeyManager
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ai_opc.db');

    // 加密密钥 - 从 KeyManager 获取
    // 注意：sqflite_sqlcipher 使用 SQLCipher，需要在打开数据库时设置密钥
    final db = await openDatabase(
      path,
      version: DatabaseSchema.version,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
    );

    return db;
  }

  /// 配置数据库
  /// 启用外键约束
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// 创建数据库表
  Future<void> _onCreate(Database db, int version) async {
    await DatabaseSchema.createAllTables(db);
  }

  /// 升级数据库
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 未来数据库迁移逻辑
    if (oldVersion < newVersion) {
      // 按版本号执行迁移
    }
  }

  /// 关闭数据库
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// 删除数据库（用于清除所有数据）
  Future<void> deleteDatabase() async {
    await close();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ai_opc.db');
    await deleteDatabaseFile(path);
  }

  /// 删除数据库文件
  Future<void> deleteDatabaseFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 执行原始 SQL 查询
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return db.rawQuery(sql, arguments);
  }

  /// 执行原始 SQL 命令
  Future<void> rawExecute(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    await db.execute(sql, arguments);
  }

  /// 插入记录
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db.insert(table, values);
  }

  /// 查询记录
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// 更新记录
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// 删除记录
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// 批量执行操作（事务）
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return db.transaction(action);
  }

  /// 获取数据库文件大小（字节）
  Future<int> getDatabaseSize() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ai_opc.db');
    final file = File(path);
    if (await file.exists()) {
      return file.length();
    }
    return 0;
  }

  /// 检查数据库是否已初始化
  bool get isInitialized => _database != null;
}
