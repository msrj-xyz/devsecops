from app import app


def test_health():
    client = app.test_client()
    r = client.get('/health')
    assert r.status_code == 200
    assert r.json == {'status': 'healthy'}


def test_status():
    client = app.test_client()
    r = client.get('/api/status')
    assert r.status_code == 200
    assert 'service' in r.json
