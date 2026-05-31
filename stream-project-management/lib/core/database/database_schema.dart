import 'package:sqflite_sqlcipher/sqflite.dart';

/// 数据库表结构定义
/// 严格按照设计文档 5.2.2 的数据模型定义
class DatabaseSchema {
  DatabaseSchema._();

  /// 数据库版本
  static const int version = 2;

  /// 项目表
  /// 设计文档：interface Project
  static const String createProjectsTable = '''
    CREATE TABLE IF NOT EXISTS projects (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      icon TEXT NOT NULL DEFAULT '📁',
      description TEXT NOT NULL DEFAULT '',
      status TEXT NOT NULL DEFAULT 'active',
      start_date INTEGER NOT NULL,
      end_date INTEGER NOT NULL,
      progress REAL NOT NULL DEFAULT 0,
      ai_prompt TEXT NOT NULL DEFAULT '',
      owner_id TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''';

  /// 任务表
  /// 设计文档：interface Task
  static const String createTasksTable = '''
    CREATE TABLE IF NOT EXISTS tasks (
      id TEXT PRIMARY KEY,
      project_id TEXT NOT NULL,
      parent_id TEXT,
      title TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      status TEXT NOT NULL DEFAULT 'todo',
      priority TEXT NOT NULL DEFAULT 'medium',
      due_date INTEGER,
      assignee_id TEXT,
      progress REAL NOT NULL DEFAULT 0,
      ai_executable INTEGER NOT NULL DEFAULT 0,
      ai_status TEXT NOT NULL DEFAULT 'idle',
      ai_result TEXT,
      attachments TEXT NOT NULL DEFAULT '[]',
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      last_modified_by TEXT NOT NULL DEFAULT '',
      FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
      FOREIGN KEY (parent_id) REFERENCES tasks(id) ON DELETE CASCADE
    )
  ''';

  /// 项目成员表
  /// 设计文档：interface ProjectMember
  static const String createProjectMembersTable = '''
    CREATE TABLE IF NOT EXISTS project_members (
      id TEXT PRIMARY KEY,
      project_id TEXT NOT NULL,
      name TEXT NOT NULL,
      permission TEXT NOT NULL DEFAULT 'read',
      share_id TEXT NOT NULL DEFAULT '',
      last_active_at INTEGER NOT NULL,
      is_online INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
    )
  ''';

  /// 操作日志表
  /// 设计文档：interface OperationLog
  static const String createOperationLogsTable = '''
    CREATE TABLE IF NOT EXISTS operation_logs (
      id TEXT PRIMARY KEY,
      project_id TEXT NOT NULL,
      task_id TEXT,
      member_id TEXT NOT NULL,
      member_name TEXT NOT NULL,
      action TEXT NOT NULL,
      field TEXT,
      old_value TEXT,
      new_value TEXT,
      timestamp INTEGER NOT NULL,
      synced INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
      FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE SET NULL
    )
  ''';

  /// AI 工作流表
  /// 设计文档：interface AIWorkflow
  static const String createAIWorkflowsTable = '''
    CREATE TABLE IF NOT EXISTS ai_workflows (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      trigger_type TEXT NOT NULL,
      trigger_condition TEXT,
      steps TEXT NOT NULL DEFAULT '[]',
      enabled INTEGER NOT NULL DEFAULT 1,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''';

  /// 分享记录表
  /// 设计文档：interface ShareRecord
  static const String createShareRecordsTable = '''
    CREATE TABLE IF NOT EXISTS share_records (
      id TEXT PRIMARY KEY,
      project_id TEXT,
      task_id TEXT,
      type TEXT NOT NULL,
      permission TEXT NOT NULL DEFAULT 'read',
      expires_at INTEGER NOT NULL,
      cloudflare_key TEXT,
      peer_id TEXT,
      created_at INTEGER NOT NULL,
      FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
      FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
    )
  ''';

  /// 离线变更队列表
  /// 设计文档 5.1 同步引擎层要求
  static const String createOfflineQueueTable = '''
    CREATE TABLE IF NOT EXISTS offline_queue (
      id TEXT PRIMARY KEY,
      operation_type TEXT NOT NULL,
      table_name TEXT NOT NULL,
      record_id TEXT NOT NULL,
      payload TEXT NOT NULL,
      timestamp INTEGER NOT NULL,
      retry_count INTEGER NOT NULL DEFAULT 0,
      status TEXT NOT NULL DEFAULT 'pending',
      error_message TEXT
    )
  ''';

  /// 所有索引定义（设计文档 10.2 性能优化）
  static const List<String> createIndexes = [
    'CREATE INDEX IF NOT EXISTS idx_tasks_project_id ON tasks(project_id)',
    'CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status)',
    'CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date)',
    'CREATE INDEX IF NOT EXISTS idx_project_members_project_id ON project_members(project_id)',
    'CREATE INDEX IF NOT EXISTS idx_operation_logs_project_id ON operation_logs(project_id)',
    'CREATE INDEX IF NOT EXISTS idx_operation_logs_timestamp ON operation_logs(timestamp)',
    'CREATE INDEX IF NOT EXISTS idx_offline_queue_status ON offline_queue(status)',
    'CREATE INDEX IF NOT EXISTS idx_offline_queue_timestamp ON offline_queue(timestamp)',
  ];

  /// 初始化所有表
  static Future<void> createAllTables(Database db) async {
    await db.execute(createProjectsTable);
    await db.execute(createTasksTable);
    await db.execute(createProjectMembersTable);
    await db.execute(createOperationLogsTable);
    await db.execute(createAIWorkflowsTable);
    await db.execute(createShareRecordsTable);
    await db.execute(createOfflineQueueTable);

    for (final indexSql in createIndexes) {
      await db.execute(indexSql);
    }
  }

  /// 项目表字段列表（用于查询）
  static const List<String> projectFields = [
    'id',
    'name',
    'icon',
    'description',
    'status',
    'start_date',
    'end_date',
    'progress',
    'ai_prompt',
    'owner_id',
    'created_at',
    'updated_at',
  ];

  /// 任务表字段列表
  static const List<String> taskFields = [
    'id',
    'project_id',
    'parent_id',
    'title',
    'description',
    'status',
    'priority',
    'due_date',
    'assignee_id',
    'progress',
    'ai_executable',
    'ai_status',
    'ai_result',
    'attachments',
    'created_at',
    'updated_at',
    'last_modified_by',
  ];

  /// 成员表字段列表
  static const List<String> memberFields = [
    'id',
    'project_id',
    'name',
    'permission',
    'share_id',
    'last_active_at',
    'is_online',
    'created_at',
    'updated_at',
  ];

  /// 操作日志表字段列表
  static const List<String> operationLogFields = [
    'id',
    'project_id',
    'task_id',
    'member_id',
    'member_name',
    'action',
    'field',
    'old_value',
    'new_value',
    'timestamp',
    'synced',
  ];

  /// AI 工作流表字段列表
  static const List<String> aiWorkflowFields = [
    'id',
    'name',
    'description',
    'trigger_type',
    'trigger_condition',
    'steps',
    'enabled',
    'created_at',
    'updated_at',
  ];

  /// 分享记录表字段列表
  static const List<String> shareRecordFields = [
    'id',
    'project_id',
    'task_id',
    'type',
    'permission',
    'expires_at',
    'cloudflare_key',
    'peer_id',
    'created_at',
  ];

  /// 离线队列表字段列表
  static const List<String> offlineQueueFields = [
    'id',
    'operation_type',
    'table_name',
    'record_id',
    'payload',
    'timestamp',
    'retry_count',
    'status',
    'error_message',
  ];
}
