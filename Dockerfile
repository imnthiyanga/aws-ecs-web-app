# ── Base image ────────────────────────────────────────────────────────────────
# node:20-alpine = Node 20 LTS on Alpine Linux (~5 MB OS vs ~70 MB on Debian).
# Alpine is the default choice for production containers: smaller attack surface,
# faster pulls from ECR, lower storage cost.
FROM node:20-alpine

# ── Working directory ──────────────────────────────────────────────────────────
# All subsequent commands run inside /app inside the container.
# Docker creates the directory if it doesn't exist.
WORKDIR /app

# ── Dependency layer (the most important caching trick) ────────────────────────
# WHY copy package*.json BEFORE the rest of the source code?
#
# Docker builds images as a stack of layers. Each layer is cached by its inputs.
# If a layer's inputs haven't changed, Docker reuses the cached layer — it does
# NOT re-run the command. This makes rebuilds dramatically faster.
#
# node_modules can take 10–60 seconds to install. If we copied ALL source files
# first, any change to app.js (even fixing a typo) would invalidate the cache
# and force a full re-install. By copying only package*.json first, Docker only
# re-runs npm ci when package.json or package-lock.json actually changes.
#
# The pattern:  COPY package files → RUN install → COPY source code
#               └── slow, cached ──┘              └── fast, always fresh ──┘
COPY package*.json ./

# npm ci = "clean install":
#   • Reads package-lock.json exactly (reproducible — same versions every time)
#   • Fails if lock file is out of sync with package.json (catches accidents)
#   • --omit=dev skips devDependencies (test runners, linters, etc.) that have
#     no place in a production container
RUN npm ci --omit=dev

# ── Application source ─────────────────────────────────────────────────────────
# Copied AFTER install so that code changes don't bust the dependency cache.
COPY app.js ./

# ── Security: drop root privileges ────────────────────────────────────────────
# By default Docker containers run as root (uid 0). That means a vulnerability
# in the app could give an attacker root access inside the container.
# node:alpine ships with a built-in "node" user (uid 1000). We switch to it
# before the process starts. The node user can read all files created above
# (default permissions are 644 for files, 755 for directories).
USER node

# ── Port declaration ───────────────────────────────────────────────────────────
# EXPOSE is documentation — it tells Docker (and humans) which port the process
# listens on. It does NOT publish the port to the host; that's done with -p at
# `docker run` time (or via the ECS task definition in Phase 5).
EXPOSE 3000

# ── Startup command ────────────────────────────────────────────────────────────
# Use the exec form (JSON array) instead of shell form ("node app.js").
# Exec form: the process gets PID 1 → Docker signals (SIGTERM on stop) reach it
# Shell form: /bin/sh gets PID 1 → signals may not reach node → dirty shutdown
CMD ["node", "app.js"]
