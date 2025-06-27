package com.microservices.jsp.controller;

import com.microservices.jsp.dto.DashboardInfo;
import com.microservices.jsp.dto.GuestTokenRequest;
import com.microservices.jsp.dto.GuestTokenResponse;
import com.microservices.jsp.dto.HealthCheckResponse;
import com.microservices.jsp.exception.SupersetAuthenticationException;
import com.microservices.jsp.exception.SupersetConnectionException;
import com.microservices.jsp.service.SupersetService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/superset")
@RequiredArgsConstructor
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:8080", "http://localhost:8088"})
@Slf4j
@Validated
public class SupersetController {

    private final SupersetService service;

    @PostMapping("/guest-token")
    public ResponseEntity<GuestTokenResponse> getGuestToken(
            @Valid @RequestBody GuestTokenRequest request,
            HttpServletRequest httpRequest) {

        try {
            log.info("Guest token requested for dashboard: {} from IP: {}",
                    request.getDashboardId(), getClientIpAddress(httpRequest));

            GuestTokenResponse response = service.getGuestToken(request);

            log.info("Guest token generated successfully for dashboard: {}", request.getDashboardId());
            return ResponseEntity.ok(response);

        } catch (SupersetAuthenticationException e) {
            log.error("Authentication failed for dashboard {}: {}", request.getDashboardId(), e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new GuestTokenResponse(null, "Authentication failed: " + e.getMessage()));

        } catch (SupersetConnectionException e) {
            log.error("Connection to Superset failed for dashboard {}: {}", request.getDashboardId(), e.getMessage());
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                    .body(new GuestTokenResponse(null, "Service temporarily unavailable: " + e.getMessage()));

        } catch (Exception e) {
            log.error("Unexpected error generating guest token for dashboard {}: {}", request.getDashboardId(), e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new GuestTokenResponse(null, "Internal server error"));
        }
    }

    @GetMapping("/dashboards")
    public ResponseEntity<List<DashboardInfo>> getAvailableDashboards() {
        try {
            log.debug("Fetching available dashboards");
            List<DashboardInfo> dashboards = service.getAvailableDashboards();
            return ResponseEntity.ok(dashboards);
        } catch (Exception e) {
            log.error("Error fetching dashboards: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<HealthCheckResponse> healthCheck() {
        try {
            boolean isConnected = service.testConnection();

            Map<String, Object> details = new HashMap<>();
            details.put("superset_connected", isConnected);
            details.put("service_name", "TTS Dashboard");
            details.put("version", "1.0.0");

            HealthCheckResponse response = HealthCheckResponse.builder()
                    .status(isConnected ? "UP" : "DOWN")
                    .message(isConnected ? "All services are operational" : "Superset connection failed")
                    .timestamp(LocalDateTime.now())
                    .details(details)
                    .build();

            HttpStatus status = isConnected ? HttpStatus.OK : HttpStatus.SERVICE_UNAVAILABLE;
            return ResponseEntity.status(status).body(response);

        } catch (Exception e) {
            log.error("Health check failed: {}", e.getMessage(), e);

            Map<String, Object> details = new HashMap<>();
            details.put("error", e.getMessage());
            details.put("service_name", "TTS Dashboard");

            HealthCheckResponse response = HealthCheckResponse.builder()
                    .status("DOWN")
                    .message("Health check failed")
                    .timestamp(LocalDateTime.now())
                    .details(details)
                    .build();

            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
        }
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }

        return request.getRemoteAddr();
    }
}
