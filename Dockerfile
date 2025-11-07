# Stage 1: Build the application
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Copy Maven/Gradle wrapper and dependencies first (for caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (cached layer)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/vidhan-portfolio-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]