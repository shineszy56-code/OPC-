/**
 * Yjs 实时协作同步
 * 设计文档 7.2：使用 Yjs 实现实时协作
 */

class YJSSyncService {
  /**
   * @param {string} shareId - 分享 ID
   * @param {Function} onUpdate - 数据更新回调
   */
  constructor(shareId, onUpdate) {
    this.shareId = shareId;
    this.onUpdate = onUpdate;
    this.ydoc = null;
    this.projectMap = null;
    this.tasksArray = null;
    this.membersArray = null;
    this.logsArray = null;
    this.provider = null;
  }

  /**
   * 初始化 Yjs 同步
   * @param {Object} initialData - 初始数据
   */
  async init(initialData = {}) {
    // 创建 Y.Doc
    this.ydoc = new Y.Doc();

    // 定义共享数据
    this.projectMap = this.ydoc.getMap('project');
    this.tasksArray = this.ydoc.getArray('tasks');
    this.membersArray = this.ydoc.getArray('members');
    this.logsArray = this.ydoc.getArray('logs');

    // 加载初始数据
    if (initialData.project) {
      this.projectMap.set('data', initialData.project);
    }
    if (initialData.tasks) {
      this.tasksArray.push([], initialData.tasks);
    }
    if (initialData.members) {
      this.membersArray.push([], initialData.members);
    }
    if (initialData.logs) {
      this.logsArray.push([], initialData.logs);
    }

    // 监听更新
    this.ydoc.on('update', (update, origin) => {
      if (origin !== this) {
        this._notifyUpdate();
      }
    });

    this.projectMap.observe(() => this._notifyUpdate());
    this.tasksArray.observe(() => this._notifyUpdate());
    this.membersArray.observe(() => this._notifyUpdate());
    this.logsArray.observe(() => this._notifyUpdate());

    // 连接到 Cloudflare WebSocket（通过 WebRTC 信令）
    // 实际实现中，这里应该连接到 WebSocket 服务器
    // 为简化，这里使用定时轮询
    this._startPolling();
  }

  /**
   * 更新项目数据
   * @param {Object} projectData 
   */
  updateProject(projectData) {
    this.projectMap.set('data', projectData);
    this._syncUpdate();
  }

  /**
   * 添加任务
   * @param {Object} task 
   */
  addTask(task) {
    this.tasksArray.push([], task);
    this._syncUpdate();
  }

  /**
   * 更新任务
   * @param {string} taskId 
   * @param {Object} updates 
   */
  updateTask(taskId, updates) {
    const index = this.tasksArray.toArray().findIndex(t => t.id === taskId);
    if (index !== -1) {
      const task = this.tasksArray.get(index);
      this.tasksArray.delete(index, 1);
      this.tasksArray.insert(index, [{ ...task, ...updates }]);
    }
    this._syncUpdate();
  }

  /**
   * 删除任务
   * @param {string} taskId 
   */
  deleteTask(taskId) {
    const index = this.tasksArray.toArray().findIndex(t => t.id === taskId);
    if (index !== -1) {
      this.tasksArray.delete(index, 1);
    }
    this._syncUpdate();
  }

  /**
   * 添加成员
   * @param {Object} member 
   */
  addMember(member) {
    this.membersArray.push([], member);
    this._syncUpdate();
  }

  /**
   * 添加操作日志
   * @param {Object} log 
   */
  addLog(log) {
    this.logsArray.push([], log);
    this._syncUpdate();
  }

  /**
   * 获取当前数据
   * @returns {Object}
   */
  getData() {
    if (!this.ydoc) return null;
    return {
      project: this.projectMap.get('data') || null,
      tasks: this.tasksArray.toArray(),
      members: this.membersArray.toArray(),
      logs: this.logsArray.toArray(),
    };
  }

  /**
   * 通知更新
   */
  _notifyUpdate() {
    if (this.onUpdate) {
      this.onUpdate(this.getData());
    }
  }

  /**
   * 同步更新到服务器
   */
  async _syncUpdate() {
    // 将 Yjs 更新发送到 Cloudflare KV
    const update = Y.encodeStateAsUpdate(this.ydoc);
    const updateBase64 = btoa(String.fromCharCode(...new Uint8Array(update)));
    
    try {
      await apiService.post(`/share/${this.shareId}/sync`, {
        diff: updateBase64,
      });
    } catch (e) {
      console.error('同步更新失败：', e);
    }
  }

  /**
   * 开始轮询服务器更新
   */
  _startPolling() {
    setInterval(async () => {
      try {
        const response = await apiService.get(`/share/${this.shareId}/sync`);
        if (response.diff) {
          const update = Uint8Array.from(atob(response.diff), c => c.charCodeAt(0));
          Y.applyUpdate(this.ydoc, update);
        }
      } catch (e) {
        console.error('拉取更新失败：', e);
      }
    }, 3000); // 每 3 秒轮询一次
  }

  /**
   * 销毁
   */
  destroy() {
    if (this.ydoc) {
      this.ydoc.destroy();
    }
  }
}

// 导出单例
const yjsSyncService = new YJSSyncService(
  new URLSearchParams(window.location.search).get('shareId') || 'demo',
  (data) => {
    if (data) {
      uiService.render(data);
    }
  }
);

window.yjsSyncService = yjsSyncService;
