package com.microservices.jsp.exception;

public class SupersetConnectionException extends RuntimeException {
    public SupersetConnectionException(String message) {
        super(message);
    }

    public SupersetConnectionException(String message, Throwable cause) {
        super(message, cause);
    }
}
