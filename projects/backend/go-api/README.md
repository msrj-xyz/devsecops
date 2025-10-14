# Go API - devsecops example

Lightweight Go backend for the DevSecOps portfolio used for CI/CD demos and security scans.

Endpoints:
- GET /health  - simple health check
- GET /api/status - basic service status

Build & run locally:

```bash
go build -o go-api
./go-api
```

Docker:

```bash
docker build -t devsecops-go-api .
docker run -p 8080:8080 devsecops-go-api
```

Tests:

```bash
go test ./...
```
