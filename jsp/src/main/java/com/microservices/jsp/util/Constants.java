package com.microservices.jsp.util;

public final class Constants {

    // API Endpoints
    public static final String API_BASE_PATH = "/api/superset";
    public static final String GUEST_TOKEN_ENDPOINT = "/guest-token";
    public static final String DASHBOARDS_ENDPOINT = "/dashboards";
    public static final String HEALTH_ENDPOINT = "/health";

    // Superset API Paths
    public static final String SUPERSET_LOGIN_PATH = "/api/v1/security/login";
    public static final String SUPERSET_GUEST_TOKEN_PATH = "/api/v1/security/guest_token/";
    public static final String SUPERSET_HEALTH_PATH = "/health";

    // Cache Keys
    public static final String ACCESS_TOKEN_CACHE_KEY = "access_token";

    // Default Values
    public static final long DEFAULT_TOKEN_CACHE_DURATION = 300; // 5 minutes
    public static final long DEFAULT_GUEST_TOKEN_DURATION = 900; // 15 minutes

    // Error Messages
    public static final String DASHBOARD_ID_REQUIRED = "Dashboard ID is required";
    public static final String AUTHENTICATION_FAILED = "Authentication failed";
    public static final String CONNECTION_FAILED = "Connection to Superset failed";
    public static final String INTERNAL_ERROR = "Internal server error";

    private Constants() {
        // Utility class - prevent instantiation
    }
}
