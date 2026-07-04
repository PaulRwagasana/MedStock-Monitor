# Containerizes the Node/Express API (backend/).

# ---- 1. Base image ----
FROM node:20-slim

# ---- 2. Working directory ----
WORKDIR /app

# ---- 3. Install dependencies first ----
COPY package.json package-lock.json ./
RUN npm ci

# ---- 4. Copy application source code ----
COPY . .

# ---- 5. Run as a non-root user (security) ----
RUN chown -R node:node /app
USER node

# ---- 6. Document the port the app listens on ----
EXPOSE 5000

# ---- 7. Check the container is healthy ----
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000', r => process.exit(r.statusCode === 200 ? 0 : 1))"

# ---- 8. Start the server ----
CMD ["node", "server.js"]
