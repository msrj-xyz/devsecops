# Secure Node.js API

A production-ready, security-hardened Node.js REST API demonstrating enterprise-grade DevSecOps practices.

## 🛡️ Security Features

### API Security
- **Rate Limiting** with Redis backend
- **Input Validation** with Joi schemas
- **SQL Injection Protection** with parameterized queries
- **NoSQL Injection Protection** with input sanitization
- **CORS** configuration with whitelist
- **Helmet.js** for security headers
- **Content Security Policy (CSP)**
- **HTTP Parameter Pollution** protection

### Authentication & Authorization
- **JWT Authentication** with RS256 signing
- **Refresh Token** rotation
- **Role-Based Access Control (RBAC)**
- **API Key Management**
- **OAuth 2.0** integration
- **Multi-Factor Authentication (MFA)**
- **Session Management** with secure cookies
- **Password Security** with bcrypt and salt

### Data Protection
- **Encryption at Rest** (AES-256)
- **Encryption in Transit** (TLS 1.3)
- **Data Masking** for sensitive information
- **PII Tokenization**
- **Secure Key Management** with HashiCorp Vault
- **Data Retention** policies
- **GDPR Compliance** features

### Monitoring & Logging
- **Structured Logging** with Winston
- **Audit Trail** for all operations
- **Security Event Monitoring**
- **Real-time Alerting**
- **Performance Monitoring** with Prometheus
- **Distributed Tracing** with Jaeger

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Run database migrations
npm run db:migrate

# Start development server
npm run dev

# Start with security monitoring
npm run dev:secure
```

## 🧪 Testing & Quality

```bash
# Unit tests with coverage
npm run test:unit

# Integration tests
npm run test:integration

# Security tests
npm run test:security

# Load testing
npm run test:load

# API documentation testing
npm run test:api-docs
```

## 🔒 Security Testing

```bash
# SAST scanning
npm run security:sast

# Dependency scanning
npm run security:deps

# API security testing
npm run security:api

# Container scanning (if using Docker)
npm run security:container
```

## 📦 Technology Stack

### Core Framework
- **Node.js 18+** with TypeScript
- **Express.js** with security middleware
- **PostgreSQL** with connection pooling
- **Redis** for caching and sessions
- **MongoDB** for document storage (optional)

### Security Libraries
- **Helmet.js** - Security headers
- **Express-rate-limit** - Rate limiting
- **Joi** - Input validation
- **Bcrypt** - Password hashing
- **JsonWebToken** - JWT handling
- **Node-rsa** - RSA encryption
- **Crypto** - Native encryption
- **DOMPurify** - XSS protection

### Monitoring & Observability
- **Winston** - Logging
- **Prometheus** - Metrics
- **Jaeger** - Distributed tracing
- **New Relic** - APM (optional)
- **Sentry** - Error tracking

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Balancer │    │   API Gateway   │    │   Rate Limiter  │
│    (Nginx)      │────│   (Express)     │────│    (Redis)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                       ┌────────┴────────┐
                       │   Auth Service  │
                       │   (JWT + RBAC)  │
                       └────────┬────────┘
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
    ┌───────▼────────┐ ┌────────▼────────┐ ┌───────▼────────┐
    │  User Service  │ │ Product Service │ │  Admin Service │
    │   (CRUD + Auth)│ │  (Business Logic)│ │  (Management)  │
    └───────┬────────┘ └────────┬────────┘ └───────┬────────┘
            │                   │                   │
    ┌───────▼────────┐ ┌────────▼────────┐ ┌───────▼────────┐
    │   PostgreSQL   │ │      Redis      │ │   Audit Logs   │
    │   (Primary DB) │ │   (Cache/Session)│ │  (Compliance)  │
    └────────────────┘ └─────────────────┘ └────────────────┘
```

## 🔐 Security Configuration

### Environment Variables
```bash
# Security
JWT_SECRET=your-super-secure-jwt-secret-256-bits
JWT_REFRESH_SECRET=your-refresh-token-secret
ENCRYPTION_KEY=your-aes-256-encryption-key
BCRYPT_ROUNDS=12

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/secure_api
DATABASE_SSL=true
REDIS_URL=redis://localhost:6379

# Security Headers
CORS_ORIGIN=https://yourdomain.com
TRUSTED_PROXIES=127.0.0.1,10.0.0.0/8
CSP_POLICY=default-src 'self'

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000  # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100
```

### Helmet Configuration
```javascript
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));
```

## 📊 API Endpoints

### Authentication
```
POST   /api/v1/auth/register     - User registration
POST   /api/v1/auth/login        - User login
POST   /api/v1/auth/refresh      - Token refresh
POST   /api/v1/auth/logout       - User logout
POST   /api/v1/auth/mfa/setup    - MFA setup
POST   /api/v1/auth/mfa/verify   - MFA verification
```

### User Management
```
GET    /api/v1/users             - List users (Admin)
GET    /api/v1/users/:id         - Get user profile
PUT    /api/v1/users/:id         - Update user profile
DELETE /api/v1/users/:id         - Delete user (Admin)
POST   /api/v1/users/:id/roles   - Assign roles (Admin)
```

### Security Endpoints
```
GET    /api/v1/security/audit    - Audit logs (Admin)
POST   /api/v1/security/report   - Security incident report
GET    /api/v1/security/metrics  - Security metrics
POST   /api/v1/security/scan     - Trigger security scan
```

## 🚨 Error Handling

```javascript
// Security-aware error handling
app.use((err, req, res, next) => {
  // Log full error for debugging
  logger.error('API Error:', {
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });

  // Return sanitized error to client
  const isDevelopment = process.env.NODE_ENV === 'development';
  
  res.status(err.status || 500).json({
    error: {
      message: isDevelopment ? err.message : 'Internal Server Error',
      status: err.status || 500,
      timestamp: new Date().toISOString(),
      requestId: req.id
    }
  });
});
```

## 📋 Security Checklist

- [x] **Authentication** implemented with JWT
- [x] **Authorization** with RBAC
- [x] **Input validation** on all endpoints
- [x] **Rate limiting** configured
- [x] **CORS** properly configured
- [x] **Security headers** with Helmet
- [x] **Password hashing** with bcrypt
- [x] **SQL injection** protection
- [x] **XSS protection** implemented
- [x] **CSRF protection** for state-changing operations
- [x] **Audit logging** for all operations
- [x] **Error handling** without information leakage
- [x] **Dependencies** regularly updated and scanned
- [x] **Secrets management** with environment variables
- [x] **TLS encryption** enforced

## 🔄 CI/CD Integration

This API is fully integrated with the DevSecOps pipeline:
- **Automated testing** on every commit
- **Security scanning** (SAST, DAST, SCA)
- **Code quality** analysis
- **Container security** scanning
- **Automated deployment** with blue-green strategy

## 📚 Documentation

- [API Documentation](docs/api.md) - OpenAPI/Swagger specs
- [Security Architecture](docs/security.md) - Security design
- [Deployment Guide](docs/deployment.md) - Production deployment
- [Monitoring Guide](docs/monitoring.md) - Observability setup
- [Troubleshooting](docs/troubleshooting.md) - Common issues

## 🏷️ Compliance

This API meets the following compliance standards:
- **OWASP API Security Top 10**
- **SOC 2 Type II** requirements
- **GDPR** data protection
- **PCI DSS** (if handling payments)
- **HIPAA** ready (with additional configuration)

---

**Maintainer**: [@msrj-xyz](https://github.com/msrj-xyz)  
**Contact**: msrj.xyz@gmail.com