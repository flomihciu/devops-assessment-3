# Stage 1 - Build React app using Node
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force

# Copy the rest of the source code
COPY . .

# Build the React app (Vite output goes to /app/dist)
RUN npm run build

# Stage 2 - Serve with Nginx
FROM nginx:alpine

# Copy built static files to Nginx web root
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx config for API proxying
COPY default.conf /etc/nginx/conf.d/default.conf

# Healthcheck for container health monitoring
HEALTHCHECK CMD wget --spider -q http://localhost || exit 1

# Expose HTTP port
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
