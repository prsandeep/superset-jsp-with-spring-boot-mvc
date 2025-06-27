package com.microservices.jsp.exception;

public class SupersetAuthenticationException extends RuntimeException {
    public SupersetAuthenticationException(String message) {
        super(message);
    }

    public SupersetAuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
}