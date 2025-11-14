# Use Tomcat 9 with a Temurin JDK 21 base image
FROM tomcat:9.0-jdk21-temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat
COPY target/*.war /usr/local/tomcat/webapps/app.war

EXPOSE 8080

CMD ["catalina.sh", "run"]


