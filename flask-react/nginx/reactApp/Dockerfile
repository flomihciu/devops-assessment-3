# Stage 1 - build
FROM node:18 AS build

WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Debug: Show the contents of /app to ensure public/index.html exists
RUN echo "Listing /app contents:" && ls -R /app

# Build the React app
RUN npm run build

# Stage 2 - serve with Nginx
FROM nginx:alpine

# Copy built files to Nginx web root (Vite outputs to dist/)
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
