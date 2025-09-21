# BAZAR Marketplace - Production Dockerfile
FROM ubuntu:22.04 as base

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa

# Install Flutter
ENV FLUTTER_VERSION=3.22.0
RUN git clone https://github.com/flutter/flutter.git /opt/flutter -b ${FLUTTER_VERSION}
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build web app
RUN flutter build web --release --web-renderer html

# Serve with nginx
FROM nginx:alpine
COPY --from=base /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
