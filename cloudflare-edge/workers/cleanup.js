// 定时清理过期数据（每天 05:00 UTC 执行）
// KV 已设置 TTL，此任务作为兜底清理
export async function cleanup(env) {
  try {
    console.log('开始清理过期数据...');

    const shareList = await env.AI_OPC_SHARE.list();
    for (const key of shareList.keys) {
      const data = await env.AI_OPC_SHARE.get(key.name);
      if (data) {
        const parsed = JSON.parse(data);
        if (parsed.expires_at && parsed.expires_at < Date.now()) {
          await env.AI_OPC_SHARE.delete(key.name);
        }
      }
    }

    const syncList = await env.AI_OPC_SYNC.list();
    for (const key of syncList.keys) {
      const data = await env.AI_OPC_SYNC.get(key.name);
      if (data) {
        const parsed = JSON.parse(data);
        const lastOp = parsed.ops?.[parsed.ops.length - 1];
        const thirtyDaysAgo = Date.now() - 30 * 24 * 60 * 60 * 1000;
        if (lastOp && lastOp.timestamp < thirtyDaysAgo) {
          await env.AI_OPC_SYNC.delete(key.name);
        }
      }
    }

    console.log('清理完成');
  } catch (error) {
    console.error('清理失败：', error.message);
  }
}
