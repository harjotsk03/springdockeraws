# Stage 1: Build the JAR
FROM maven:3.9.3-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Package the app (skip tests to speed up)
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built jar from the previous stage
COPY --from=build /app/target/demo-1.0.0.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java","-jar","app.jar"]
