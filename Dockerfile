# Use the official NGINX image from Docker Hub
FROM nginx:latest

# Copy your static HTML files to the NGINX container's default location
COPY ./html /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80
