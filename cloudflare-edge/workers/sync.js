// 协作同步 API — POST/GET /sync/:id
// CRDT delta 通过 Cloudflare KV 中继，客户端轮询拉取（1-2s 间隔）
import { Hono } from 'hono';

const syncRoutes = new Hono();

// POST /sync/:id — 推送 CRDT 变更
syncRoutes.post('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    const body = await c.req.json();
    const { ops, member_id, seq } = body;

    if (!ops || !member_id) {
      return c.json({ error: '缺少必需参数' }, 400);
    }

    const existing = await c.env.AI_OPC_SYNC.get(id);
    const syncData = existing ? JSON.parse(existing) : { ops: [], seq: 0 };

    syncData.ops.push({ ops, member_id, seq: syncData.seq++, timestamp: Date.now() });

    // 只保留最近 500 条 op，防止 KV value 过大
    if (syncData.ops.length > 500) {
      syncData.ops = syncData.ops.slice(-500);
    }

    const expiresAt = Math.floor(Date.now() / 1000) + 30 * 24 * 60 * 60;
    await c.env.AI_OPC_SYNC.put(id, JSON.stringify(syncData), { expiration: expiresAt });

    return c.json({ success: true, seq: syncData.seq });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

// GET /sync/:id?since=<seq> — 拉取指定 seq 之后的变更
syncRoutes.get('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    const since = parseInt(c.req.query('since') || '0', 10);

    const data = await c.env.AI_OPC_SYNC.get(id);
    if (!data) return c.json({ ops: [], seq: 0 });

    const syncData = JSON.parse(data);
    const ops = syncData.ops.filter((op) => op.seq > since);
    return c.json({ ops, seq: syncData.seq });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

export { syncRoutes };
