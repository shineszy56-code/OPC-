/**
 * UI 渲染服务
 * 设计文档 7.2：纯 HTML + Tailwind CSS + Vanilla JavaScript
 */

class UIService {
  constructor() {
    this.taskEditMode = {}; // 任务编辑模式状态
  }

  /**
   * 渲染所有数据
   * @param {Object} data - 项目数据
   */
  render(data) {
    if (!data) return;

    this.renderProject(data.project);
    this.renderMembers(data.members || []);
    this.renderTasks(data.tasks || []);
    this.renderLogs(data.logs || []);
  }

  /**
   * 渲染项目信息
   */
  renderProject(project) {
    if (!project) return;

    const iconEl = document.getElementById('project-icon');
    const nameEl = document.getElementById('project-name');
    const progressTextEl = document.getElementById('progress-text');
    const progressBarEl = document.getElementById('progress-bar');

    if (iconEl) iconEl.textContent = project.icon || '📁';
    if (nameEl) nameEl.textContent = project.name || '未命名项目';

    const progress = project.progress || 0;
    if (progressTextEl) progressTextEl.textContent = `${(progress * 100).toFixed(0)}%`;
    if (progressBarEl) progressBarEl.style.width = `${progress * 100}%`;
  }

  /**
   * 渲染在线成员列表
   */
  renderMembers(members) {
    const listEl = document.getElementById('member-list');
    if (!listEl) return;

    const onlineCount = members.filter(m => m.is_online).length;

    const countEl = document.getElementById('online-count');
    if (countEl) countEl.textContent = `${onlineCount} 人在线`;

    listEl.innerHTML = members.map(m => `
      <div class="flex items-center space-x-2">
        <div class="relative">
          <div class="w-8 h-8 rounded-full bg-purple-600 flex items-center justify-center text-white text-sm font-bold">
            ${(m.name || '?').charAt(0).toUpperCase()}
          </div>
          ${m.is_online ? '<div class="online-dot"></div>' : ''}
        </div>
        <span class="text-sm text-gray-300">${this.escapeHtml(m.name)}</span>
      </div>
    `).join('');
  }

  /**
   * 渲染任务列表
   */
  renderTasks(tasks) {
    const listEl = document.getElementById('task-list');
    if (!listEl) return;

    if (tasks.length === 0) {
      listEl.innerHTML = `
        <div class="text-center text-gray-500 py-8">
          <div class="text-4xl mb-2">📝</div>
          <div>暂无任务</div>
        </div>
      `;
      return;
    }

    // 分离父任务和子任务
    const parentTasks = tasks.filter(t => !t.parent_id);
    const subtasksMap = {};
    tasks.forEach(t => {
      if (t.parent_id) {
        if (!subtasksMap[t.parent_id]) subtasksMap[t.parent_id] = [];
        subtasksMap[t.parent_id].push(t);
      }
    });

    listEl.innerHTML = parentTasks.map(task => this.renderTaskCard(task, subtasksMap[task.id] || [])).join('');
  }

  /**
   * 渲染单个任务卡片
   */
  renderTaskCard(task, subtasks = []) {
    const statusClass = `status-${task.status}`;
    const priorityClass = task.priority ? `priority-${task.priority}` : '';

    let html = `
      <div class="task-card bg-gray-800 rounded-lg p-4 mb-3" data-task-id="${task.id}">
        <div class="flex items-center justify-between mb-2">
          <div class="flex items-center space-x-2">
            <span class="w-3 h-3 rounded-full ${this.getStatusColor(task.status)}"></span>
            <span class="font-medium ${task.status === 'done' ? 'line-through text-gray-500' : ''}">${this.escapeHtml(task.title)}</span>
          </div>
          <span class="text-xs px-2 py-1 rounded ${this.getPriorityBg(task.priority)} ${this.getPriorityTextColor(task.priority)}">${this.getPriorityText(task.priority)}</span>
        </div>
    `;

    // 子任务
    if (subtasks.length > 0) {
      html += `<div class="ml-4 mt-2 space-y-2">`;
      subtasks.forEach(sub => {
        html += `
          <div class="flex items-center space-x-2 text-sm">
            <span class="w-2 h-2 rounded-full ${this.getStatusColor(sub.status)}"></span>
            <span class="${sub.status === 'done' ? 'line-through text-gray-500' : 'text-gray-300'}">${this.escapeHtml(sub.title)}</span>
          </div>
        `;
      });
      html += `</div>`;
    }

    // 操作按钮（权限内）
    if (window.hasEditPermission) {
      html += `
        <div class="flex items-center justify-between mt-3 pt-3 border-t border-gray-700">
          <div class="flex space-x-2">
            <button onclick="appService.setTaskStatus('${task.id}', 'todo')" class="text-xs px-2 py-1 rounded ${task.status === 'todo' ? 'bg-gray-600 text-white' : 'text-gray-400 hover:text-white'}">待办</button>
            <button onclick="appService.setTaskStatus('${task.id}', 'in_progress')" class="text-xs px-2 py-1 rounded ${task.status === 'in_progress' ? 'bg-blue-600 text-white' : 'text-gray-400 hover:text-white'}">进行中</button>
            <button onclick="appService.setTaskStatus('${task.id}', 'done')" class="text-xs px-2 py-1 rounded ${task.status === 'done' ? 'bg-green-600 text-white' : 'text-gray-400 hover:text-white'}">完成</button>
            <button onclick="appService.setTaskStatus('${task.id}', 'blocked')" class="text-xs px-2 py-1 rounded ${task.status === 'blocked' ? 'bg-red-600 text-white' : 'text-gray-400 hover:text-white'}">阻塞</button>
          </div>
          <button onclick="uiService.toggleTaskEdit('${task.id}')" class="text-xs text-gray-400 hover:text-white">✏️</button>
        </div>
      `;

      // 编辑区域（默认隐藏）
      html += `
        <div id="edit-${task.id}" class="hidden mt-3 pt-3 border-t border-gray-700">
          <input type="text" id="title-${task.id}" value="${this.escapeHtml(task.title)}" class="w-full bg-gray-700 text-white rounded px-3 py-2 text-sm mb-2">
          <div class="flex space-x-2">
            <button onclick="appService.updateTaskTitle('${task.id}')" class="text-xs bg-purple-600 hover:bg-purple-700 px-3 py-1 rounded text-white">保存</button>
            <button onclick="uiService.toggleTaskEdit('${task.id}')" class="text-xs bg-gray-600 hover:bg-gray-700 px-3 py-1 rounded text-white">取消</button>
          </div>
        </div>
      `;
    }

    html += `</div>`;
    return html;
  }

  /**
   * 切换任务编辑模式
   */
  toggleTaskEdit(taskId) {
    const el = document.getElementById(`edit-${taskId}`);
    if (el) {
      el.classList.toggle('hidden');
    }
  }

  /**
   * 渲染操作日志时间线
   */
  renderLogs(logs) {
    const timelineEl = document.getElementById('log-timeline');
    if (!timelineEl) return;

    if (logs.length === 0) {
      timelineEl.innerHTML = `
        <div class="text-center text-gray-500 py-8">
          <div>暂无操作日志</div>
        </div>
      `;
      return;
    }

    // 按日期分组
    const grouped = this.groupLogsByDate(logs);

    timelineEl.innerHTML = Object.entries(grouped).map(([date, items]) => `
      <div class="mb-4">
        <div class="text-xs text-gray-500 mb-2">${date}</div>
        ${items.map(log => this.renderLogItem(log)).join('')}
      </div>
    `).join('');
  }

  /**
   * 渲染单个日志条目
   */
  renderLogItem(log) {
    const actionText = this.getActionText(log.action);
    const time = new Date(log.timestamp).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });

    return `
      <div class="flex items-start space-x-3 mb-3">
        <div class="mt-1.5">
          <div class="w-2 h-2 rounded-full ${this.getActionColor(log.action)}"></div>
          <div class="w-0.5 bg-gray-700 h-8 mx-auto"></div>
        </div>
        <div class="flex-1">
          <div class="text-sm">
            <span class="font-medium text-white">${this.escapeHtml(log.member_name)}</span>
            <span class="text-gray-400"> ${actionText}</span>
            ${log.field ? `<span class="text-purple-400"> ${this.escapeHtml(log.field)}</span>` : ''}
            ${log.new_value ? `<span class="text-green-400"> ${this.escapeHtml(log.new_value)}</span>` : ''}
          </div>
          <div class="text-xs text-gray-500">${time}</div>
        </div>
      </div>
    `;
  }

  // ==================== 工具方法 ====================

  /**
   * 按日期分组日志
   */
  groupLogsByDate(logs) {
    const grouped = {};
    logs.forEach(log => {
      const date = new Date(log.timestamp).toLocaleDateString('zh-CN');
      if (!grouped[date]) grouped[date] = [];
      grouped[date].push(log);
    });
    return grouped;
  }

  /**
   * 获取状态颜色
   */
  getStatusColor(status) {
    const colors = {
      todo: 'bg-gray-500',
      in_progress: 'bg-blue-500',
      done: 'bg-green-500',
      blocked: 'bg-red-500',
    };
    return colors[status] || 'bg-gray-500';
  }

  /**
   * 获取优先级背景色
   */
  getPriorityBg(priority) {
    const colors = {
      low: 'bg-green-900',
      medium: 'bg-yellow-900',
      high: 'bg-red-900',
    };
    return colors[priority] || 'bg-gray-900';
  }

  /**
   * 获取优先级文字颜色
   */
  getPriorityTextColor(priority) {
    const colors = {
      low: 'text-green-400',
      medium: 'text-yellow-400',
      high: 'text-red-400',
    };
    return colors[priority] || 'text-gray-400';
  }

  /**
   * 获取操作类型文本
   */
  getActionText(action) {
    const texts = {
      create: '创建了',
      update: '更新了',
      delete: '删除了',
      status_change: '修改了状态',
      progress_change: '更新了进度',
    };
    return texts[action] || action;
  }

  /**
   * 获取操作类型颜色
   */
  getActionColor(action) {
    const colors = {
      create: 'bg-green-500',
      update: 'bg-blue-500',
      delete: 'bg-red-500',
      status_change: 'bg-yellow-500',
      progress_change: 'bg-purple-500',
    };
    return colors[action] || 'bg-gray-500';
  }

  /**
   * HTML 转义
   */
  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
}

// 导出单例
window.uiService = new UIService();
