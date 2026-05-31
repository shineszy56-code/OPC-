/**
 * 网页协作端主应用逻辑
 * 设计文档 7.1 + 7.2：纯 HTML + Tailwind CSS + Vanilla JavaScript
 */

class App {
  constructor() {
    this.shareId = null;
    this.shareKey = null;
    this.projectData = null;
    this.hasEditPermission = false;
    this.init();
  }

  /**
   * 初始化应用
   */
  async init() {
    try {
      // 1. 解析 URL 哈希中的分享密钥
      const hash = window.location.hash;
      if (!hash || hash.length < 2) {
        this.showError('无效的分享链接');
        return;
      }

      this.shareKey = cryptoService.parseShareKeyFromUrl(hash);
      this.shareId = this.getShareIdFromUrl();

      // 2. 从 Cloudflare 获取加密数据
      const encryptedData = await apiService.fetchShareData(this.shareId);
      if (!encryptedData) {
        this.showError('分享已过期或不存在');
        return;
      }

      // 3. 使用分享密钥解密
      const jsonStr = cryptoService.decryptFromShare(encryptedData, this.shareKey);
      this.projectData = JSON.parse(jsonStr);

      // 4. 检查权限
      this.hasEditPermission = this.checkPermission();

      // 5. 初始化 Yjs 同步
      await yjsSyncService.init(this.projectData, this.shareId);

      // 6. 渲染 UI
      uiService.render(this.projectData);
      this.setupPermissionUI();

      // 7. 显示主内容
      document.getElementById('loading').classList.add('hidden');
      document.getElementById('main').classList.remove('hidden');

      // 8. 启动实时同步
      this.startRealtimeSync();

    } catch (error) {
      console.error('初始化失败：', error);
      this.showError(`加载失败：${error.message}`);
    }
  }

  /**
   * 从 URL 解析分享 ID
   * @returns {string|null}
   */
  getShareIdFromUrl() {
    const path = window.location.pathname;
    const matches = path.match(/\/share\/([^/]+)/);
    return matches ? matches[1] : null;
  }

  /**
   * 检查权限
   * @returns {boolean}
   */
  checkPermission() {
    if (!this.projectData || !this.projectData.permission) return false;
    const permission = this.projectData.permission;
    return ['edit', 'admin'].includes(permission);
  }

  /**
   * 设置权限相关 UI
   */
  setupPermissionUI() {
    const addButton = document.getElementById('add-task-btn');
    if (addButton) {
      if (this.hasEditPermission) {
        addButton.classList.remove('hidden');
      } else {
        addButton.classList.add('hidden');
      }
    }

    // 设置全局权限标志（供 ui.js 使用）
    window.hasEditPermission = this.hasEditPermission;
  }

  /**
   * 启动实时同步
   */
  startRealtimeSync() {
    // 监听 Yjs 更新
    yjsSyncService.onUpdate((updatedData) => {
      this.projectData = updatedData;
      uiService.render(updatedData);
      this.setupPermissionUI();
    });

    // 监听在线状态
    this.startHeartbeat();
  }

  /**
   * 心跳检测在线状态
   */
  startHeartbeat() {
    setInterval(async () => {
      try {
        await apiService.updateOnlineStatus(this.shareId, true);
      } catch (e) {
        console.warn('心跳失败：', e);
      }
    }, 30000); // 每 30 秒
  }

  /**
   * 更新任务状态
   * @param {string} taskId 
   * @param {string} newStatus 
   */
  async updateTaskStatus(taskId, newStatus) {
    if (!this.hasEditPermission) {
      alert('没有编辑权限');
      return;
    }

    try {
      // 通过 Yjs 更新
      yjsSyncService.updateTask(taskId, { status: newStatus });

      // 记录操作日志
      await apiService.submitLog(this.shareId, {
        member_id: this.getDeviceId(),
        member_name: '协作者',
        action: 'status_change',
        field: 'status',
        old_value: '',
        new_value: newStatus,
      });

    } catch (error) {
      console.error('更新任务状态失败：', error);
      alert('更新失败，请重试');
    }
  }

  /**
   * 分配任务负责人
   * @param {string} taskId 
   * @param {string} assigneeId 
   */
  async assignTask(taskId, assigneeId) {
    if (!this.hasEditPermission) {
      alert('没有编辑权限');
      return;
    }

    try {
      yjsSyncService.updateTask(taskId, { assignee_id: assigneeId });
    } catch (error) {
      console.error('分配任务失败：', error);
    }
  }

  /**
   * 提交任务成果
   * @param {string} taskId 
   * @param {string} result 
   */
  async submitTaskResult(taskId, result) {
    if (!this.hasEditPermission) {
      alert('没有编辑权限');
      return;
    }

    try {
      yjsSyncService.updateTask(taskId, {
        ai_result: result,
        status: 'done',
      });

      await apiService.submitLog(this.shareId, {
        member_id: this.getDeviceId(),
        member_name: '协作者',
        action: 'update',
        field: 'ai_result',
        old_value: '',
        new_value: '已提交成果',
      });

    } catch (error) {
      console.error('提交成果失败：', error);
    }
  }

  /**
   * 添加评论
   * @param {string} taskId 
   * @param {string} comment 
   */
  async addComment(taskId, comment) {
    try {
      // 评论通过操作日志实现
      await apiService.submitLog(this.shareId, {
        member_id: this.getDeviceId(),
        member_name: '协作者',
        action: 'update',
        field: 'comment',
        old_value: '',
        new_value: comment,
      });

      alert('评论已提交');
    } catch (error) {
      console.error('添加评论失败：', error);
      alert('提交失败，请重试');
    }
  }

  /**
   * 获取设备 ID（匿名）
   * @returns {string}
   */
  getDeviceId() {
    let deviceId = localStorage.getItem('device_id');
    if (!deviceId) {
      deviceId = 'device_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
      localStorage.setItem('device_id', deviceId);
    }
    return deviceId;
  }

  /**
   * 显示错误
   * @param {string} message 
   */
  showError(message) {
    const loadingEl = document.getElementById('loading');
    const errorEl = document.getElementById('loading-error');

    if (loadingEl) loadingEl.classList.add('hidden');
    if (errorEl) {
      errorEl.textContent = message;
      errorEl.classList.remove('hidden');
    }
  }

  /**
   * 处理页面关闭
   */
  cleanup() {
    if (yjsSyncService) {
      yjsSyncService.destroy();
    }
  }
}

// 创建应用实例
let app;

window.addEventListener('DOMContentLoaded', () => {
  app = new App();
  window.app = app;
});

window.addEventListener('beforeunload', () => {
  if (app) {
    app.cleanup();
  }
});
