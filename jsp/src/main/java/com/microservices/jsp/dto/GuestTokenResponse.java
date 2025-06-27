package com.microservices.jsp.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GuestTokenResponse {
    private String token;
    private String error;
    private long expiresAt;

    public GuestTokenResponse(String token) {
        this.token = token;
        this.expiresAt = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes
    }

    public GuestTokenResponse(String token, String error) {
        this.token = token;
        this.error = error;
    }

    public boolean isSuccess() {
        return token != null && error == null;
    }
}
