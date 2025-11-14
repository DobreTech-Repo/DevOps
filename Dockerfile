# Base Tomcat 10 + Java 21 image
FROM tomcat:10.1.10-jdk21

# Install curl
USER root
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Keep pod running
CMD ["catalina.sh", "run"]

# Expose Tomcat port
EXPOSE 8080


