package com.microservices.jsp.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GuestTokenRequest {
    @NotBlank(message = "Dashboard ID is required")
    private String dashboardId;
}