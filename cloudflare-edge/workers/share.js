/// 分享 API 路由
/// 设计文档 6.2.2：分享相关接口
import { Hono } from 'hono';

const shareRoutes = new Hono();

/// POST /share - 创建分享链接
shareRoutes.post('/', async (c) => {
  try {
    const body = await c.req.json();
    const { project_id, permission, expires_in } = body;

    if (!project_id || !permission) {
      return c.json({ error: '缺少必需参数' }, 400);
    }

    const shareId = crypto.randomUUID();
    const expiresAt = Date.now() + (expires_in || 2592000) * 1000; // 默认 30 天

    /// 存储到 KV
    await c.env.AI_OPC_SHARE.put(
      shareId,
      JSON.stringify({
        project_id,
        permission,
        expires_at: expiresAt,
        created_at: Date.now(),
      }),
      { expiration: Math.floor(expiresAt / 1000) }
    );

    return c.json({ share_id: shareId }, 201);
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

/// GET /share/:id - 获取分享数据
shareRoutes.get('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    const data = await c.env.AI_OPC_SHARE.get(id);

    if (!data) {
      return c.json({ error: '分享已过期或不存在' }, 404);
    }

    const parsed = JSON.parse(data);
    if (parsed.expires_at < Date.now()) {
      await c.env.AI_OPC_SHARE.delete(id);
      return c.json({ error: '分享已过期' }, 404);
    }

    return c.json(parsed);
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

/// DELETE /share/:id - 删除分享链接
shareRoutes.delete('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    await c.env.AI_OPC_SHARE.delete(id);
    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

/// POST /share/:id/member - 添加协作成员
shareRoutes.post('/:id/member', async (c) => {
  try {
    const { id } = c.req.param();
    const body = await c.req.json();
    const { member_id, permission } = body;

    if (!member_id || !permission) {
      return c.json({ error: '缺少必需参数' }, 400);
    }

    /// 获取现有分享
    const data = await c.env.AI_OPC_SHARE.get(id);
    if (!data) {
      return c.json({ error: '分享不存在' }, 404);
    }

    const parsed = JSON.parse(data);
    if (!parsed.members) parsed.members = [];

    parsed.members.push({ member_id, permission, joined_at: Date.now() });
    parsed.updated_at = Date.now();

    await c.env.AI_OPC_SHARE.put(id, JSON.stringify(parsed), {
      expiration: Math.floor(parsed.expires_at / 1000),
    });

    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

/// PUT /share/:id/member/:memberId - 修改成员权限
shareRoutes.put('/:id/member/:memberId', async (c) => {
  try {
    const { id, memberId } = c.req.param();
    const body = await c.req.json();
    const { permission } = body;

    const data = await c.env.AI_OPC_SHARE.get(id);
    if (!data) {
      return c.json({ error: '分享不存在' }, 404);
    }

    const parsed = JSON.parse(data);
    const member = parsed.members?.find((m) => m.member_id === memberId);
    if (member) {
      member.permission = permission;
      parsed.updated_at = Date.now();
      await c.env.AI_OPC_SHARE.put(id, JSON.stringify(parsed), {
        expiration: Math.floor(parsed.expires_at / 1000),
      });
    }

    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

/// DELETE /share/:id/member/:memberId - 移除协作成员
shareRoutes.delete('/:id/member/:memberId', async (c) => {
  try {
    const { id, memberId } = c.req.param();

    const data = await c.env.AI_OPC_SHARE.get(id);
    if (!data) {
      return c.json({ error: '分享不存在' }, 404);
    }

    const parsed = JSON.parse(data);
    parsed.members = parsed.members?.filter((m) => m.member_id !== memberId) || [];
    parsed.updated_at = Date.now();

    await c.env.AI_OPC_SHARE.put(id, JSON.stringify(parsed), {
      expiration: Math.floor(parsed.expires_at / 1000),
    });

    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

export { shareRoutes };
