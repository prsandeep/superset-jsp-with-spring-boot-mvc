package com.microservices.jsp.service;

import com.microservices.jsp.config.SupersetConfig;
import com.microservices.jsp.dto.DashboardInfo;
import com.microservices.jsp.dto.GuestTokenRequest;
import com.microservices.jsp.dto.GuestTokenResponse;
import com.microservices.jsp.exception.SupersetAuthenticationException;
import com.microservices.jsp.exception.SupersetConnectionException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
@Slf4j
public class SupersetService {

    private final SupersetConfig config;
    private final RestTemplate restTemplate = new RestTemplate();

    // Token cache
    private final Map<String, String> tokenCache = new ConcurrentHashMap<>();
    private final Map<String, Long> tokenExpiryCache = new ConcurrentHashMap<>();

    public GuestTokenResponse getGuestToken(GuestTokenRequest request) {
        try {
            log.info("Generating guest token for dashboard: {}", request.getDashboardId());

            // Step 1: Get access token (with caching)
            String accessToken = getAccessToken();

            // Step 2: Generate guest token
            String guestToken = generateGuestToken(accessToken, request.getDashboardId());

            log.info("Guest token generated successfully for dashboard: {}", request.getDashboardId());
            return new GuestTokenResponse(guestToken);

        } catch (Exception e) {
            log.error("Error generating guest token for dashboard {}: {}", request.getDashboardId(), e.getMessage(), e);

            if (e instanceof RestClientException) {
                throw new SupersetConnectionException("Failed to connect to Superset: " + e.getMessage(), e);
            } else if (e.getMessage().contains("authentication") || e.getMessage().contains("401")) {
                // Clear cached token on auth failure
                clearTokenCache();
                throw new SupersetAuthenticationException("Authentication failed: " + e.getMessage(), e);
            } else {
                throw new RuntimeException("Failed to generate guest token: " + e.getMessage(), e);
            }
        }
    }

    private String getAccessToken() {
        final String cacheKey = "access_token";

        // Check if cached token is still valid
        if (tokenCache.containsKey(cacheKey) &&
                tokenExpiryCache.containsKey(cacheKey) &&
                System.currentTimeMillis() < tokenExpiryCache.get(cacheKey)) {
            log.debug("Using cached access token");
            return tokenCache.get(cacheKey);
        }

        String loginUrl = config.getUrl() + "/api/v1/security/login";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> loginPayload = Map.of(
                "username", config.getUsername(),
                "password", config.getPassword(),
                "provider", "db",
                "refresh", true
        );

        try {
            log.debug("Authenticating with Superset at: {}", loginUrl);

            ResponseEntity<Map> loginResp = restTemplate.postForEntity(
                    loginUrl, new HttpEntity<>(loginPayload, headers), Map.class);

            if (loginResp.getStatusCode() != HttpStatus.OK) {
                throw new SupersetAuthenticationException("Login failed with status: " + loginResp.getStatusCode());
            }

            Map<String, Object> responseBody = loginResp.getBody();
            if (responseBody == null || !responseBody.containsKey("access_token")) {
                throw new SupersetAuthenticationException("No access token in login response");
            }

            String accessToken = (String) responseBody.get("access_token");

            // Cache the token
            tokenCache.put(cacheKey, accessToken);
            tokenExpiryCache.put(cacheKey, System.currentTimeMillis() + (config.getTokenCacheDuration() * 1000));

            log.debug("Access token obtained and cached for {} seconds", config.getTokenCacheDuration());
            return accessToken;

        } catch (RestClientException e) {
            log.error("Failed to authenticate with Superset: {}", e.getMessage());
            throw new SupersetConnectionException("Failed to authenticate with Superset", e);
        }
    }

    private String generateGuestToken(String accessToken, String dashboardId) {
        String guestTokenUrl = config.getUrl() + "/api/v1/security/guest_token/";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(accessToken);

        Map<String, Object> guestPayload = Map.of(
                "user", Map.of(
                        "username", config.getUsername(),
                        "first_name", config.getFirstName() != null ? config.getFirstName() : "TTS",
                        "last_name", config.getLastName() != null ? config.getLastName() : "User",
                        "email", config.getEmail() != null ? config.getEmail() : "user@tts.com"
                ),
                "resources", new Object[] {
                        Map.of("type", "dashboard", "id", dashboardId)
                },
                "rls", new Object[] {} // Row Level Security rules
        );

        try {
            log.debug("Generating guest token for dashboard: {}", dashboardId);

            ResponseEntity<Map> guestTokenResp = restTemplate.postForEntity(
                    guestTokenUrl, new HttpEntity<>(guestPayload, headers), Map.class);

            if (guestTokenResp.getStatusCode() != HttpStatus.OK) {
                throw new RuntimeException("Guest token request failed with status: " + guestTokenResp.getStatusCode());
            }

            Map<String, Object> responseBody = guestTokenResp.getBody();
            if (responseBody == null || !responseBody.containsKey("token")) {
                throw new RuntimeException("No guest token in response");
            }

            return (String) responseBody.get("token");

        } catch (RestClientException e) {
            log.error("Failed to generate guest token: {}", e.getMessage());
            throw new SupersetConnectionException("Failed to generate guest token", e);
        }
    }

    public List<DashboardInfo> getAvailableDashboards() {
        // In a real implementation, this would fetch from Superset API
        // For now, return static list
        return Arrays.asList(
                new DashboardInfo("dash-1", "Sales Analytics", "Sales performance metrics and KPIs", "Business", true, null),
                new DashboardInfo("dash-2", "Operations Dashboard", "Operational metrics and monitoring", "Operations", true, null),
                new DashboardInfo("dash-3", "Financial Reports", "Financial analytics and reporting", "Finance", true, null),
                new DashboardInfo("dash-4", "Customer Analytics", "Customer behavior and insights", "Customer", true, null)
        );
    }

    public boolean testConnection() {
        try {
            String healthUrl = config.getUrl() + "/health";
            ResponseEntity<String> response = restTemplate.getForEntity(healthUrl, String.class);
            return response.getStatusCode() == HttpStatus.OK;
        } catch (Exception e) {
            log.error("Superset connection test failed: {}", e.getMessage());
            return false;
        }
    }

    private void clearTokenCache() {
        tokenCache.clear();
        tokenExpiryCache.clear();
        log.debug("Token cache cleared");
    }
}