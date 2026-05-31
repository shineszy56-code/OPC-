/**
 * Cloudflare Workers API 调用服务
 * 设计文档 6.2.2：API 接口定义
 */

class ApiService {
  constructor() {
    this.baseUrl = window.location.origin; // 同域部署
    this.pendingRequests = 0;
    this.onRequestChange = null; // 请求状态回调
  }

  /**
   * 获取分享数据
   * GET /share/:id
   * @param {string} shareId - 分享 ID
   * @returns {Promise<Object>} 分享数据
   */
  async getShareData(shareId) {
    this._setLoading(true);
    try {
      const response = await fetch(`${this.baseUrl}/share/${shareId}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('分享链接已过期或不存在');
        }
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      console.error('[ApiService] 获取分享数据失败:', error);
      throw error;
    } finally {
      this._setLoading(false);
    }
  }

  /**
   * 提交操作日志
   * POST /share/:id/log
   * @param {string} shareId - 分享 ID
   * @param {Object} logData - 日志数据
   * @returns {Promise<Object>} 响应结果
   */
  async postLog(shareId, logData) {
    this._setLoading(true);
    try {
      const response = await fetch(`${this.baseUrl}/share/${shareId}/log`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(logData),
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      console.error('[ApiService] 提交日志失败:', error);
      throw error;
    } finally {
      this._setLoading(false);
    }
  }

  /**
   * 同步数据
   * POST /sync
   * @param {Object} syncData - 同步数据
   * @returns {Promise<Object>} 响应结果
   */
  async sync(syncData) {
    this._setLoading(true);
    try {
      const response = await fetch(`${this.baseUrl}/sync`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(syncData),
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      console.error('[ApiService] 同步失败:', error);
      throw error;
    } finally {
      this._setLoading(false);
    }
  }

  /**
   * 上传文件
   * POST /file
   * @param {File} file - 文件对象
   * @returns {Promise<Object>} 上传结果（含文件 ID）
   */
  async uploadFile(file) {
    this._setLoading(true);
    try {
      const formData = new FormData();
      formData.append('file', file);

      const response = await fetch(`${this.baseUrl}/file`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      console.error('[ApiService] 上传文件失败:', error);
      throw error;
    } finally {
      this._setLoading(false);
    }
  }

  /**
   * 下载文件
   * GET /file/:id
   * @param {string} fileId - 文件 ID
   * @returns {Promise<Blob>} 文件 Blob
   */
  async downloadFile(fileId) {
    this._setLoading(true);
    try {
      const response = await fetch(`${this.baseUrl}/file/${fileId}`, {
        method: 'GET',
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.blob();
    } catch (error) {
      console.error('[ApiService] 下载文件失败:', error);
      throw error;
    } finally {
      this._setLoading(false);
    }
  }

  /**
   * 设置加载状态
   * @param {boolean} isLoading - 是否加载中
   * @private
   */
  _setLoading(isLoading) {
    this.pendingRequests += isLoading ? 1 : -1;
    this.pendingRequests = Math.max(0, this.pendingRequests);

    if (this.onRequestChange) {
      this.onRequestChange(this.pendingRequests > 0);
    }
  }
}

// 导出单例
window.apiService = new ApiService();
