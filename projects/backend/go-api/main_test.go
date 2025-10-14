package main

import (
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestHealthHandler(t *testing.T) {
    req := httptest.NewRequest(http.MethodGet, "/health", nil)
    rr := httptest.NewRecorder()
    healthHandler(rr, req)

    if rr.Code != http.StatusOK {
        t.Fatalf("expected status 200 got %d", rr.Code)
    }
    if rr.Body.String() != `{"status":"healthy"}` {
        t.Fatalf("unexpected body: %s", rr.Body.String())
    }
}

func TestStatusHandler(t *testing.T) {
    req := httptest.NewRequest(http.MethodGet, "/api/status", nil)
    rr := httptest.NewRecorder()
    statusHandler(rr, req)

    if rr.Code != http.StatusOK {
        t.Fatalf("expected status 200 got %d", rr.Code)
    }
}
