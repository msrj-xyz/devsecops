const request = require('supertest');
const app = require('./server');

describe('DevSecOps Node.js API', () => {
  let server;

  beforeAll(() => {
    server = app.listen(0); // Use random port for testing
  });

  afterAll((done) => {
    server.close(done);
  });

  describe('Health Endpoints', () => {
    test('GET /health should return health status', async () => {
      const res = await request(app)
        .get('/health')
        .expect(200);

      expect(res.body).toHaveProperty('status', 'healthy');
      expect(res.body).toHaveProperty('timestamp');
      expect(res.body).toHaveProperty('uptime');
      expect(res.body).toHaveProperty('version');
    });

    test('GET /api/status should return API status', async () => {
      const res = await request(app)
        .get('/api/status')
        .expect(200);

      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('security_features');
      expect(res.body).toHaveProperty('deployment_info');
      expect(res.body.security_features).toBeInstanceOf(Array);
    });
  });

  describe('Security Endpoints', () => {
    test('GET /api/security-test should return security test results', async () => {
      const res = await request(app)
        .get('/api/security-test')
        .expect(200);

      expect(res.body).toHaveProperty('security_tests');
      expect(res.body).toHaveProperty('penetration_test_results');
      expect(res.body).toHaveProperty('compliance_status');
      expect(res.body.compliance_status.owasp_top_10).toBe('COMPLIANT');
    });

    test('GET /api/metrics should return DevSecOps metrics', async () => {
      const res = await request(app)
        .get('/api/metrics')
        .expect(200);

      expect(res.body).toHaveProperty('devsecops_metrics');
      expect(res.body).toHaveProperty('ci_cd_metrics');
      expect(res.body).toHaveProperty('infrastructure_metrics');
    });
  });

  describe('Data Validation', () => {
    test('POST /api/data should validate input successfully', async () => {
      const validData = {
        name: 'John Doe',
        email: 'john@example.com',
        message: 'This is a test message'
      };

      const res = await request(app)
        .post('/api/data')
        .send(validData)
        .expect(200);

      expect(res.body).toHaveProperty('success', true);
      expect(res.body).toHaveProperty('processed_data');
      expect(res.body).toHaveProperty('security_checks');
    });

    test('POST /api/data should reject invalid input', async () => {
      const invalidData = {
        name: '', // Empty name
        email: 'invalid-email', // Invalid email
        message: 'x'.repeat(1001) // Too long message
      };

      const res = await request(app)
        .post('/api/data')
        .send(invalidData)
        .expect(400);

      expect(res.body).toHaveProperty('error', 'Validation failed');
      expect(res.body).toHaveProperty('details');
    });
  });

  describe('Security Headers', () => {
    test('Should include security headers in responses', async () => {
      const res = await request(app)
        .get('/health')
        .expect(200);

      expect(res.headers).toHaveProperty('x-content-type-options', 'nosniff');
      expect(res.headers).toHaveProperty('x-frame-options', 'DENY');
      expect(res.headers).toHaveProperty('x-xss-protection', '1; mode=block');
    });
  });

  describe('Rate Limiting', () => {
    test('Should handle multiple requests within limits', async () => {
      // Make several requests quickly
      const promises = Array(5).fill().map(() => 
        request(app).get('/health')
      );

      const responses = await Promise.all(promises);
      responses.forEach(res => {
        expect(res.status).toBe(200);
      });
    });
  });

  describe('Error Handling', () => {
    test('Should return 404 for non-existent routes', async () => {
      const res = await request(app)
        .get('/non-existent-route')
        .expect(404);

      expect(res.body).toHaveProperty('error', 'Route not found');
      expect(res.body).toHaveProperty('available_endpoints');
    });
  });

  describe('CORS Configuration', () => {
    test('Should handle CORS preflight requests', async () => {
      const res = await request(app)
        .options('/api/status')
        .set('Origin', 'http://localhost:3000')
        .set('Access-Control-Request-Method', 'GET');

      expect(res.status).toBe(204);
    });
  });
});