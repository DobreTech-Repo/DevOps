# Use the official nginx image as a base
FROM nginx:latest

# Copy the HTML file into the Nginx directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
