package com.bazar.marketplace.events.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * User Domain Events for BAZAR Marketplace
 * 
 * Events related to user lifecycle, authentication, and profile management
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
public class UserEvent extends BaseEvent {

    // Event Types
    public static final String USER_REGISTERED = "UserRegistered";
    public static final String USER_VERIFIED = "UserVerified";
    public static final String USER_LOGGED_IN = "UserLoggedIn";
    public static final String USER_LOGGED_OUT = "UserLoggedOut";
    public static final String USER_PROFILE_UPDATED = "UserProfileUpdated";
    public static final String USER_PASSWORD_CHANGED = "UserPasswordChanged";
    public static final String USER_DEACTIVATED = "UserDeactivated";
    public static final String USER_REACTIVATED = "UserReactivated";

    @JsonProperty("email")
    private String email;

    @JsonProperty("firstName")
    private String firstName;

    @JsonProperty("lastName")
    private String lastName;

    @JsonProperty("phone")
    private String phone;

    @JsonProperty("isActive")
    private Boolean isActive;

    @JsonProperty("isVerified")
    private Boolean isVerified;

    @JsonProperty("loginMethod")
    private String loginMethod;

    @JsonProperty("ipAddress")
    private String ipAddress;

    @JsonProperty("userAgent")
    private String userAgent;

    @JsonProperty("previousValues")
    private Object previousValues;

    // Constructors for specific events

    public static UserEvent userRegistered(String userId, String email, String firstName, 
                                         String lastName, String phone, String correlationId) {
        UserEvent event = new UserEvent();
        event.setEventType(USER_REGISTERED);
        event.setAggregateId(userId);
        event.setAggregateType("User");
        event.setSource("user-service");
        event.setUserId(userId);
        event.setCorrelationId(correlationId);
        event.setEmail(email);
        event.setFirstName(firstName);
        event.setLastName(lastName);
        event.setPhone(phone);
        event.setIsActive(true);
        event.setIsVerified(false);
        return event;
    }

    public static UserEvent userLoggedIn(String userId, String email, String loginMethod, 
                                       String ipAddress, String userAgent, String correlationId) {
        UserEvent event = new UserEvent();
        event.setEventType(USER_LOGGED_IN);
        event.setAggregateId(userId);
        event.setAggregateType("User");
        event.setSource("user-service");
        event.setUserId(userId);
        event.setCorrelationId(correlationId);
        event.setEmail(email);
        event.setLoginMethod(loginMethod);
        event.setIpAddress(ipAddress);
        event.setUserAgent(userAgent);
        return event;
    }

    public static UserEvent userProfileUpdated(String userId, String email, String firstName, 
                                             String lastName, String phone, Object previousValues, 
                                             String correlationId) {
        UserEvent event = new UserEvent();
        event.setEventType(USER_PROFILE_UPDATED);
        event.setAggregateId(userId);
        event.setAggregateType("User");
        event.setSource("user-service");
        event.setUserId(userId);
        event.setCorrelationId(correlationId);
        event.setEmail(email);
        event.setFirstName(firstName);
        event.setLastName(lastName);
        event.setPhone(phone);
        event.setPreviousValues(previousValues);
        return event;
    }
}
