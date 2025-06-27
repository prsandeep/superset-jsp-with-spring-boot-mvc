package com.microservices.jsp.exception;

public class DashboardNotFoundException extends RuntimeException {
    public DashboardNotFoundException(String message) {
        super(message);
    }

    public DashboardNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
