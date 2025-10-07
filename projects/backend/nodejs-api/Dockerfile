# Multi-stage build for security and optimization
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Add security: install security updates
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# Copy package files
COPY package*.json ./

# Install dependencies with security audit
RUN npm ci --only=production --audit && \
    npm audit fix --audit-level=moderate && \
    npm cache clean --force

# Copy application code
COPY . .

# Remove development files and sensitive information
RUN rm -f .env .env.local .env.*.local && \
    rm -rf test/ tests/ __tests__/ *.test.js *.spec.js

# Change ownership to non-root user
RUN chown -R nodejs:nodejs /usr/src/app

# Production stage
FROM node:18-alpine

# Install security updates and utilities
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init curl && \
    rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# Set working directory
WORKDIR /usr/src/app

# Copy built application from builder stage
COPY --from=builder --chown=nodejs:nodejs /usr/src/app .

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "server.js"]