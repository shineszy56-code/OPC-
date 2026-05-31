/**
 * 端到端加密解密服务
 * 使用 Web Crypto API 实现 AES-256-GCM
 */

class CryptoService {
  /**
   * AES-256-GCM 加密
   * @param {string} plaintext - 明文
   * @param {Uint8Array} key - 32字节密钥
   * @returns {Promise<string>} base64(nonce(12字节) + ciphertext + tag(16字节))
   */
  async encryptAES256GCM(plaintext, key) {
    const encoder = new TextEncoder();
    const data = encoder.encode(plaintext);

    // 生成 12 字节随机 nonce
    const nonce = crypto.getRandomValues(new Uint8Array(12));

    // 导入密钥
    const cryptoKey = await crypto.subtle.importKey(
      'raw',
      key,
      { name: 'AES-GCM', length: 128 },
      false,
      ['encrypt']
    );

    // 加密
    const ciphertext = await crypto.subtle.encrypt(
      { name: 'AES-GCM', iv: nonce },
      cryptoKey,
      data
    );

    // 拼接 nonce + ciphertext
    const result = new Uint8Array(nonce.length + ciphertext.byteLength);
    result.set(nonce);
    result.set(new Uint8Array(ciphertext), nonce.length);

    return btoa(String.fromCharCode(...result));
  }

  /**
   * AES-256-GCM 解密
   * @param {string} ciphertext - base64(nonce + ciphertext + tag)
   * @param {Uint8Array} key - 32字节密钥
   * @returns {Promise<string>} 明文
   */
  async decryptAES256GCM(ciphertext, key) {
    const data = Uint8Array.from(atob(ciphertext), c => c.charCodeAt(0));
    
    if (data.length < 28) {
      throw new Error('密文长度无效');
    }

    const nonce = data.slice(0, 12);
    const cipher = data.slice(12);

    // 导入密钥
    const cryptoKey = await crypto.subtle.importKey(
      'raw',
      key,
      { name: 'AES-GCM', length: 128 },
      false,
      ['decrypt']
    );

    // 解密
    const plaintext = await crypto.subtle.decrypt(
      { name: 'AES-GCM', iv: nonce },
      cryptoKey,
      cipher
    );

    const decoder = new TextDecoder();
    return decoder.decode(plaintext);
  }

  /**
   * 从 URL 哈希中解析分享密钥
   * @param {string} hash - URL 哈希（去掉 #）
   * @returns {Uint8Array} 32字节密钥
   */
  parseShareKeyFromUrl(hash) {
    const keyStr = hash.startsWith('#') ? hash.slice(1) : hash;
    const key = Uint8Array.from(atob(keyStr), c => c.charCodeAt(0));
    
    if (key.length !== 32) {
      throw new Error('密钥长度无效，应为 32 字节');
    }
    
    return key;
  }

  /**
   * 为分享链接生成一次性密钥
   * @returns {Uint8Array} 32字节随机密钥
   */
  generateShareKey() {
    return crypto.getRandomValues(new Uint8Array(32));
  }

  /**
   * 分享数据加密（使用分享密钥）
   * @param {string} data - JSON 字符串
   * @param {Uint8Array} shareKey - 分享密钥
   * @returns {Promise<string>} 加密后的 base64 字符串
   */
  async encryptForShare(data, shareKey) {
    return this.encryptAES256GCM(data, shareKey);
  }

  /**
   * 分享数据解密（使用分享密钥）
   * @param {string} encryptedData - 加密后的 base64 字符串
   * @param {Uint8Array} shareKey - 分享密钥
   * @returns {Promise<string>} 解密后的 JSON 字符串
   */
  async decryptFromShare(encryptedData, shareKey) {
    return this.decryptAES256GCM(encryptedData, shareKey);
  }
}

// 导出单例
const cryptoService = new CryptoService();
