// app.js — the entry point for the Express web server

const express = require('express');

const app = express();

// Read PORT from the environment so Docker/ECS can inject it at runtime.
// Falls back to 3000 when running locally without any environment variable set.
const PORT = process.env.PORT || 3000;

// --- Routes ---

// GET / — the "home" page returned as plain HTML.
// In Phase 2 we'll serve this from inside a Docker container.
app.get('/', (req, res) => {
  const serverTime = new Date().toLocaleString();

  res.send(`
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>AWS ECS Web App</title>
  <style>
    body { font-family: sans-serif; max-width: 600px; margin: 80px auto; text-align: center; }
    h1   { font-size: 2.5rem; }
    p    { color: #555; font-size: 1.1rem; }
  </style>
</head>
<body>
  <h1>Welcome from app! 🚀</h1>
  <p>Server time: <strong>${serverTime}</strong></p>
</body>
</html>
  `);
});

// GET /health — a lightweight JSON endpoint.
// AWS ECS (and load balancers) ping this path to decide whether the container
// is healthy. It must return a 2xx status; we use 200 with a simple body.
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// --- Start server ---

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`  GET /        → welcome page`);
  console.log(`  GET /health  → health check (JSON)`);
});
