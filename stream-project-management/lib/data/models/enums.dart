/// 项目状态枚举
enum ProjectStatus {
  active,
  completed,
  archived,
}

/// 任务状态枚举
enum TaskStatus {
  todo,
  inProgress,
  done,
  blocked,
}

/// 任务优先级枚举
enum TaskPriority {
  low,
  medium,
  high,
}

/// 成员权限枚举
enum MemberPermission {
  read,
  comment,
  edit,
  admin,
}

/// 操作日志动作枚举
enum LogAction {
  create,
  update,
  delete,
  statusChange,
  progressChange,
}

/// 分享类型枚举
enum ShareType {
  cloudflare,
  p2p,
}

/// AI 工作流触发类型枚举
enum WorkflowTriggerType {
  manual,
  taskCreated,
  taskStatusChanged,
  schedule,
}

/// AI 任务执行状态枚举
enum AIStatus {
  idle,
  running,
  completed,
  failed,
}

/// 离线队列状态枚举
enum OfflineQueueStatus {
  pending,
  synced,
  failed,
}
