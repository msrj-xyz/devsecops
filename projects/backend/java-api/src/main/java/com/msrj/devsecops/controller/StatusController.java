package com.msrj.devsecops.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class StatusController {

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "healthy");
    }

    @GetMapping("/api/status")
    public Map<String, String> status() {
        return Map.of("service", "java-api", "version", "1.0.0");
    }
}
