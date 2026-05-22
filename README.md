# AWS ECS Web App — Phase 1

A minimal Node.js/Express web server.  
This is **Phase 1** of a multi-phase project that will eventually be containerised with Docker and deployed to AWS ECS.

---

## Project structure

```
aws-ecs-web-app/
├── app.js          ← Express application (routes + server startup)
├── package.json    ← Project metadata and npm dependencies
├── .gitignore      ← Files Git should never track
└── README.md       ← This file
```

---

## Prerequisites

- [Node.js](https://nodejs.org/) v18 or later  
- npm (bundled with Node.js)

---

## Install dependencies

```bash
npm install
```

This downloads Express into `node_modules/` (listed in `package.json`).

---

## Run locally

```bash
npm start
```

The server starts on **port 3000** by default.  
To use a different port, set the `PORT` environment variable:

```bash
# Linux / macOS
PORT=8080 npm start

# Windows PowerShell
$env:PORT=8080; npm start
```

---

## Endpoints

| Method | Path      | Description                          | Response type |
|--------|-----------|--------------------------------------|---------------|
| GET    | `/`       | Welcome page with current server time | HTML          |
| GET    | `/health` | Health check (used by AWS ECS)        | JSON          |

### Example responses

**GET /**
```html
<h1>Welcome from app! 🚀</h1>
<p>Server time: ...</p>
```

**GET /health**
```json
{ "status": "ok" }
```

---

## Coming next

- **Phase 2** — Dockerise the app (`Dockerfile`, `.dockerignore`)
- **Phase 3** — Push the image to Amazon ECR
- **Phase 4** — CI/CD pipeline (GitHub Actions)
- **Phase 5** — Deploy to AWS ECS (Fargate)
