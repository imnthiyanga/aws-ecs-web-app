# AWS ECS Web App — Phase 1 & 2

A minimal Node.js/Express web server.  
This is **Phase 1** of a multi-phase project that will eventually be containerised with Docker and deployed to AWS ECS.

---

## Project structure

```
aws-ecs-web-app/
├── app.js           ← Express application (routes + server startup)
├── package.json     ← Project metadata and npm dependencies
├── Dockerfile       ← Instructions to build the container image
├── .dockerignore    ← Files excluded from the Docker build context
├── .gitignore       ← Files Git should never track
└── README.md        ← This file
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

---

## Running with Docker

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running

### Build the image

```bash
docker build -t my-web-app:latest .
```

`-t my-web-app:latest` tags the image with a name and version.  
`.` tells Docker to look for the `Dockerfile` in the current directory.

### Run the container

```bash
docker run -d -p 3000:3000 --name my-web-app my-web-app:latest
```

| Flag | Meaning |
|------|---------|
| `-d` | Detached — runs in the background |
| `-p 3000:3000` | Maps host port 3000 → container port 3000 |
| `--name my-web-app` | Gives the container a human-friendly name |

### Test the endpoints

```bash
curl http://localhost:3000/
curl http://localhost:3000/health
```

### View container logs

```bash
docker logs my-web-app

# Follow live (like tail -f):
docker logs -f my-web-app
```

### Stop and remove the container

```bash
docker stop my-web-app
docker rm my-web-app
```

Or in one command:

```bash
docker rm -f my-web-app
```

### Check image size

```bash
docker images my-web-app
```

---

## Coming next

- **Phase 3** — Push the image to Amazon ECR
- **Phase 4** — CI/CD pipeline (GitHub Actions)
- **Phase 5** — Deploy to AWS ECS (Fargate)
