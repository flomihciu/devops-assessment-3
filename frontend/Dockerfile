# Use Nginx to serve static files
FROM nginx:alpine

# Copy all frontend files into the Nginx web root
COPY . /usr/share/nginx/html

# Expose port 80 and run Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
