// Personal KB 同步 API
//
// 设计原则：Worker 只做加密数据的搬运，不解密、不理解内容。
// 所有数据由 Flutter 端在上传前完成 AES-256 加密，下载后本地解密。
//
// 路由：
//   GET    /kb/:syncId/manifest         — 拉取文件清单（manifest.json，已加密）
//   PUT    /kb/:syncId/manifest         — 更新文件清单
//   GET    /kb/:syncId/files/*          — 下载单个加密文件
//   PUT    /kb/:syncId/files/*          — 上传单个加密文件
//   DELETE /kb/:syncId/files/*          — 删除单个文件
//
// syncId：设备首次使用时生成的 UUID，存于 Keychain，通过扫码传递给其他设备。
// R2 路径结构：{syncId}/manifest.json, {syncId}/files/notes/abc.enc, ...

import { Hono } from 'hono';

const kbRoutes = new Hono();

// GET /kb/:syncId/manifest
kbRoutes.get('/:syncId/manifest', async (c) => {
  try {
    const { syncId } = c.req.param();
    const obj = await c.env.OPC_KB.get(`${syncId}/manifest.json`);
    if (!obj) return c.json({ files: [] });
    return new Response(obj.body, { headers: { 'Content-Type': 'application/octet-stream' } });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

// PUT /kb/:syncId/manifest
kbRoutes.put('/:syncId/manifest', async (c) => {
  try {
    const { syncId } = c.req.param();
    const body = await c.req.arrayBuffer();
    await c.env.OPC_KB.put(`${syncId}/manifest.json`, body);
    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

// GET /kb/:syncId/files/*
kbRoutes.get('/:syncId/files/*', async (c) => {
  try {
    const syncId = c.req.param('syncId');
    const filePath = c.req.param('*');
    const obj = await c.env.OPC_KB.get(`${syncId}/files/${filePath}`);
    if (!obj) return c.json({ error: '文件不存在' }, 404);
    return new Response(obj.body, { headers: { 'Content-Type': 'application/octet-stream' } });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

// PUT /kb/:syncId/files/*
kbRoutes.put('/:syncId/files/*', async (c) => {
  try {
    const syncId = c.req.param('syncId');
    const filePath = c.req.param('*');
    const body = await c.req.arrayBuffer();
    await c.env.OPC_KB.put(`${syncId}/files/${filePath}`, body);
    return c.json({ success: true }, 201);
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

// DELETE /kb/:syncId/files/*
kbRoutes.delete('/:syncId/files/*', async (c) => {
  try {
    const syncId = c.req.param('syncId');
    const filePath = c.req.param('*');
    await c.env.OPC_KB.delete(`${syncId}/files/${filePath}`);
    return c.json({ success: true });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

export { kbRoutes };
