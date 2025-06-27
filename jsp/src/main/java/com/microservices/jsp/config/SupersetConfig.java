package com.microservices.jsp.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "superset")
@Data
public class SupersetConfig {
    private String url;
    private String username;
    private String password;
    private String firstName;
    private String lastName;
    private String email;
    private String defaultDashboardId;
    private long tokenCacheDuration = 300; // 5 minutes default
}