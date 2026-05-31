import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/project.dart';
import '../services/project_service.dart';

/// 项目列表状态
final projectListProvider = FutureProvider<List<Project>>((ref) async {
  final service = ProjectService();
  return service.getAllProjects();
});

/// 活跃项目数量
final activeProjectCountProvider = FutureProvider<int>((ref) async {
  final service = ProjectService();
  return service.getActiveProjectCount();
});

/// 搜索查询
final projectSearchQueryProvider = StateProvider<String>((ref) => '');

/// 搜索结果
final projectSearchResultProvider = FutureProvider<List<Project>>((ref) async {
  final query = ref.watch(projectSearchQueryProvider);
  if (query.isEmpty) return [];

  final service = ProjectService();
  return service.searchProjects(query);
});

/// 当前选中的项目 ID
final selectedProjectIdProvider = StateProvider<String?>((ref) => null);

/// 当前选中的项目
final selectedProjectProvider = FutureProvider<Project?>((ref) async {
  final projectId = ref.watch(selectedProjectIdProvider);
  if (projectId == null) return null;

  final service = ProjectService();
  return service.getProjectById(projectId);
});

/// 项目操作 Notifier
final projectNotifierProvider = NotifierProvider<ProjectNotifier, void>(
  ProjectNotifier.new,
);

class ProjectNotifier extends Notifier<void> {
  @override
  void build() {}

  /// 创建项目
  Future<Project> createProject({
    required String name,
    String icon = '📁',
    String description = '',
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final service = ProjectService();
    final project = await service.createProject(
      name: name,
      icon: icon,
      description: description,
      startDate: startDate,
      endDate: endDate,
    );

    // 刷新列表
    ref.invalidate(projectListProvider);
    return project;
  }

  /// 更新项目
  Future<void> updateProject(Project project) async {
    final service = ProjectService();
    await service.updateProject(project);

    // 刷新列表和详情
    ref.invalidate(projectListProvider);
    ref.invalidate(selectedProjectProvider);
  }

  /// 归档项目
  Future<void> archiveProject(String id) async {
    final service = ProjectService();
    await service.archiveProject(id);

    ref.invalidate(projectListProvider);
  }

  /// 删除项目
  Future<void> deleteProject(String id) async {
    final service = ProjectService();
    await service.deleteProject(id);

    ref.invalidate(projectListProvider);
  }

  /// 选择项目
  void selectProject(String? id) {
    ref.read(selectedProjectIdProvider.notifier).state = id;
  }

  /// 搜索项目
  void search(String query) {
    ref.read(projectSearchQueryProvider.notifier).state = query;
  }
}
