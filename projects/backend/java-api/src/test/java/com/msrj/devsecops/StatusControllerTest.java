package com.msrj.devsecops;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
public class StatusControllerTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void healthEndpoint() {
        ResponseEntity<String> resp = restTemplate.getForEntity("/health", String.class);
        assertThat(resp.getStatusCode().is2xxSuccessful()).isTrue();
    }
}
