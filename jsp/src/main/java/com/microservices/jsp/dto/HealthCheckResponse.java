package com.microservices.jsp.dto;

import lombok.Data;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
public class HealthCheckResponse {
    private String status;
    private String message;
    private LocalDateTime timestamp;
    private Map<String, Object> details;
}