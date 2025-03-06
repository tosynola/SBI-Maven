# Use Maven image to build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src/ src/

# Package the application
RUN mvn clean package -DskipTests

# Use a lightweight Java runtime image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy built .war file from the build stage
COPY --from=build /app/target/*.war app.war

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.war"]

