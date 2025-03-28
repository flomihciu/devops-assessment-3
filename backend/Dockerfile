FROM node:16-alpine

WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the app code
COPY . .

EXPOSE 5000
CMD ["node", "index.js"]  # or "server.js" if that's your entry file
