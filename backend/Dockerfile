# Use the official Maven image to build the app
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the pom and source code
COPY pom.xml .
COPY src ./src

# Build the application (skip tests for speed if needed)
RUN mvn clean package -DskipTests

# Use a minimal base image for running the app
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Set environment variables if needed (optional fallback)
ENV PORT=8080

EXPOSE 8080

# Run the app
CMD ["java", "-jar", "app.jar"]
