// 操作日志 API — GET/POST /log/:id
import { Hono } from 'hono';

const logRoutes = new Hono();

// GET /log/:id — 获取操作日志
logRoutes.get('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    const data = await c.env.AI_OPC_SHARE.get(id);
    if (!data) return c.json({ logs: [] });

    const parsed = JSON.parse(data);
    return c.json({ logs: parsed.logs || [] });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

// POST /log/:id — 写入操作日志
logRoutes.post('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    const { member_id, member_name, action, field, old_value, new_value } = await c.req.json();

    if (!member_id || !action) {
      return c.json({ error: '缺少必需参数' }, 400);
    }

    const data = await c.env.AI_OPC_SHARE.get(id);
    const parsed = data ? JSON.parse(data) : { logs: [] };

    parsed.logs = parsed.logs || [];
    parsed.logs.push({
      id: crypto.randomUUID(),
      member_id,
      member_name,
      action,
      field,
      old_value,
      new_value,
      timestamp: Date.now(),
    });

    // 只保留最近 7 天
    const sevenDaysAgo = Date.now() - 7 * 24 * 60 * 60 * 1000;
    parsed.logs = parsed.logs.filter((log) => log.timestamp >= sevenDaysAgo);

    await c.env.AI_OPC_SHARE.put(id, JSON.stringify(parsed), {
      expiration: Math.floor(parsed.expires_at / 1000),
    });

    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

export { logRoutes };
