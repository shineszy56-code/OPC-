import { Hono } from 'hono';
import { shareRoutes } from './share.js';
import { syncRoutes } from './sync.js';
import { fileRoutes } from './file.js';
import { logRoutes } from './log.js';
import { kbRoutes } from './kb.js';
import { cleanup } from './cleanup.js';

const app = new Hono();

// CORS
app.use('*', async (c, next) => {
  c.res.headers.set('Access-Control-Allow-Origin', '*');
  c.res.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  c.res.headers.set('Access-Control-Allow-Headers', 'Content-Type');
  if (c.req.method === 'OPTIONS') return c.text('', 204);
  await next();
});

app.get('/health', (c) => c.json({ status: 'ok', timestamp: Date.now() }));

app.route('/share', shareRoutes);
app.route('/sync', syncRoutes);
app.route('/file', fileRoutes);
app.route('/log', logRoutes);
app.route('/kb', kbRoutes);

export default {
  fetch: app.fetch,
  async scheduled(event, env, ctx) {
    await cleanup(env);
  },
};
