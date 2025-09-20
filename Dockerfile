# Multi-stage Dockerfile for BAZAR Marketplace
# Optimized for production deployment with minimal image size

# =================================================================
# Stage 1: Build Stage
# =================================================================
FROM maven:3.9.6-openjdk-17-slim AS builder

# Set working directory
WORKDIR /app

# Copy Maven configuration files
COPY pom.xml ./
COPY .mvn .mvn
COPY mvnw ./

# Download dependencies (cached layer if pom.xml doesn't change)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests -B

# Extract the JAR layers for better caching
RUN java -Djarmode=layertools -jar target/*.jar extract

# =================================================================
# Stage 2: Runtime Stage
# =================================================================
FROM openjdk:17-jre-slim AS runtime

# Install required packages for production
RUN apt-get update && apt-get install -y \
    curl \
    dumb-init \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user for security
RUN groupadd -r bazar && useradd -r -g bazar -s /bin/false bazar

# Set working directory
WORKDIR /app

# Copy application layers from builder stage
COPY --from=builder app/dependencies/ ./
COPY --from=builder app/spring-boot-loader/ ./
COPY --from=builder app/snapshot-dependencies/ ./
COPY --from=builder app/application/ ./

# Create logs directory
RUN mkdir -p /app/logs && chown -R bazar:bazar /app

# Switch to non-root user
USER bazar

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Set JVM options for containerized environment
ENV JAVA_OPTS="-Xmx1g -Xms512m -XX:+UseG1GC -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Run the application
CMD ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.JarLauncher"]

# =================================================================
# Labels for metadata
# =================================================================
LABEL maintainer="BAZAR Development Team"
LABEL version="1.0.0"
LABEL description="BAZAR Marketplace - Spring Boot Microservice"
LABEL org.opencontainers.image.title="BAZAR Marketplace"
LABEL org.opencontainers.image.description="Enterprise e-commerce marketplace supporting 5M users"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="BAZAR"
LABEL org.opencontainers.image.licenses="MIT"
