# Multi-stage build for security and optimization
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Add security: create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S reactuser -u 1001

# Copy package files
COPY package*.json ./

# Install dependencies with security audit
RUN npm ci --only=production

# Copy source code
COPY . .

# Change ownership to non-root user
RUN chown -R reactuser:nodejs /app
USER reactuser

# Build the application
RUN npm run build

# Production stage with nginx
FROM nginx:alpine

# Install security updates
RUN apk update && apk upgrade && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

# Remove default nginx config
RUN rm -rf /usr/share/nginx/html/*

# Copy built app from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom nginx configuration with security headers
COPY nginx.conf /etc/nginx/nginx.conf

# Create non-root user for nginx
RUN addgroup -g 1001 -S nginx-group && \
    adduser -S nginx-user -u 1001 -G nginx-group

# Set proper permissions
RUN chown -R nginx-user:nginx-group /usr/share/nginx/html && \
    chown -R nginx-user:nginx-group /var/cache/nginx && \
    chown -R nginx-user:nginx-group /var/log/nginx && \
    chown -R nginx-user:nginx-group /etc/nginx/conf.d

# Create directories for nginx pid and logs
RUN mkdir -p /var/run/nginx && \
    chown nginx-user:nginx-group /var/run/nginx

# Switch to non-root user
USER nginx-user

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]