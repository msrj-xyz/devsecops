# Python API - devsecops example

Simple Flask backend for CI/CD and security demo.

Endpoints:
- GET /health
- GET /api/status

Run locally:

```bash
pip install -r requirements.txt
python app.py
```

Tests:

```bash
pytest -q
```

Docker:

```bash
docker build -t devsecops-python-api .
docker run -p 5000:5000 devsecops-python-api
```
