# Containerizes the Node/Express API (backend/).

# ---- 1. Base image ----
FROM node:20-slim

# ---- 2. Working directory ----
WORKDIR /app

# ---- 3. Install dependencies first ----
COPY package.json package-lock.json ./
RUN npm install

# ---- 4. Copy application source code ----
COPY . .

# ---- 5. Run as a non-root user (security) ----
RUN chown -R node:node /app
USER node

# ---- 6. Document the port the app listens on ----
EXPOSE 5000

# ---- 7. Start the server ----
CMD ["node", "server.js"]
