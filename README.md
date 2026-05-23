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

## Deployment (CI/CD — Phase 4)

Deployments are fully automated via GitHub Actions.

### How it works

Every push to the `main` branch triggers `.github/workflows/deploy.yml`, which:

1. Builds the Docker image on a GitHub-hosted runner
2. Pushes it to **Amazon ECR** with two tags: `:latest` and `:<short-commit-sha>`
3. Injects the new image URI into `task-definition.json`
4. Registers a new ECS task definition revision
5. Performs a **rolling update** on the ECS service and waits for health checks to pass

### Triggering a deploy

| How | When |
|-----|------|
| Automatic | Push any commit to `main` |
| Manual | GitHub → **Actions** tab → "Build and Deploy to AWS ECS" → **Run workflow** |

### Monitoring a deployment

1. Go to your repo on GitHub → **Actions** tab
2. Click the running workflow — you'll see each step in real time
3. Step 6 ("Deploy to ECS service") holds until ECS reports all tasks healthy
4. Total time from push to live: **~3 minutes**

### After deployment

Once the workflow goes green, your updated app is live at your ALB DNS name.  
To find it: AWS Console → EC2 → Load Balancers → copy the DNS name.

---

## Coming next

- **Phase 5** — Deploy to AWS ECS (Fargate)
