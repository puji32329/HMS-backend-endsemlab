# Step 1: Build the JAR using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy entire project
COPY . .

# Build the jar file
RUN mvn clean package -DskipTests

# Step 2: Run the Spring Boot application
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy jar from build stage (inside target/)
COPY --from=build /app/target/*.jar app.jar

# Expose your backend port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]


