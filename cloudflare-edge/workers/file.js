/// 文件上传/下载 API
/// 设计文档 6.2.2：POST /file、GET /file/{id}
import { Hono } from 'hono';

const fileRoutes = new Hono();

/// POST /file - 上传分享文件
fileRoutes.post('/', async (c) => {
  try {
    const formData = await c.req.formData();
    const file = formData.get('file');
    const fileId = crypto.randomUUID();

    if (!file) {
      return c.json({ error: '未找到文件' }, 400);
    }

    // 获取文件字节
    const arrayBuffer = await file.arrayBuffer();
    const uint8Array = new Uint8Array(arrayBuffer);

    // 上传到 R2
    await c.env.AI_OPC_FILES.put(fileId, uint8Array, {
      httpMetadata: {
        contentType: file.type,
        contentDisposition: `attachment; filename="${file.name}"`,
      },
      // TTL 最长 30 天
      expiration: Math.floor(Date.now() / 1000) + 30 * 24 * 60 * 60,
    });

    return c.json({ file_id: fileId, name: file.name, size: file.size }, 201);
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

/// GET /file/{id} - 下载分享文件
fileRoutes.get('/:id', async (c) => {
  try {
    const { id } = c.req.param();
    const object = await c.env.AI_OPC_FILES.get(id);

    if (!object) {
      return c.json({ error: '文件已过期或不存在' }, 404);
    }

    // 检查是否过期
    if (object.expiration && object.expiration * 1000 < Date.now()) {
      await c.env.AI_OPC_FILES.delete(id);
      return c.json({ error: '文件已过期' }, 404);
    }

    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set('etag', object.httpEtag);

    return new Response(object.body, {
      headers,
    });
  } catch (error) {
    return c.json({ error: error.message }, 500);
  }
});

export { fileRoutes };
