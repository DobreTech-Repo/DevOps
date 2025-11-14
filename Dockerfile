# Use official Tomcat base image with Java 21
FROM tomcat:10.1.10-jdk21

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Install curl to allow downloading WARs inside the container (optional, for dynamic WAR fetch)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/local/tomcat

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

