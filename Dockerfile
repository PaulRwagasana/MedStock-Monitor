# Containerizes the Node/Express API (backend/).

# ---- Stage 1: Install dependencies ----
FROM node:20-slim AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# ---- Stage 2: Production image ----
FROM node:20-slim AS production

WORKDIR /app

# Copy only the installed dependencies from the builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application source code
COPY . .

# Run as a non-root user for security
RUN chown -R node:node /app
USER node

# Document the port the app listens on
EXPOSE 5000

# Check the container is healthy
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000', r => process.exit(r.statusCode === 200 ? 0 : 1))"

# Start the server
CMD ["node", "server.js"]
