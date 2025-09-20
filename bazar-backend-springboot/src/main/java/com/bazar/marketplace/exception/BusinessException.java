package com.bazar.marketplace.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

/**
 * Business Exception
 * Used for business logic violations and domain-specific errors
 */
@Getter
public class BusinessException extends RuntimeException {
    
    private final HttpStatus status;
    private final String error;
    private final Object details;
    
    public BusinessException(String message) {
        super(message);
        this.status = HttpStatus.BAD_REQUEST;
        this.error = "Business Logic Error";
        this.details = null;
    }
    
    public BusinessException(String message, HttpStatus status) {
        super(message);
        this.status = status;
        this.error = "Business Logic Error";
        this.details = null;
    }
    
    public BusinessException(String message, String error, HttpStatus status) {
        super(message);
        this.status = status;
        this.error = error;
        this.details = null;
    }
    
    public BusinessException(String message, String error, HttpStatus status, Object details) {
        super(message);
        this.status = status;
        this.error = error;
        this.details = details;
    }
}
