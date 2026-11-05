package com.metersay.metersay_backend.dto;

import com.metersay.metersay_backend.model.RideStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideDetailsResponse {

    private Long rideId;
    private RideStatus status;
    private String pickupAddress;
    private Double pickupLatitude;
    private Double pickupLongitude;
    private String dropAddress;
    private Double dropLatitude;
    private Double dropLongitude;

    // Driver details (populated when assigned)
    private Long driverId;
    private String driverName;
    private String driverPhoneNumber;
    private String autoNumber;
    private String autoModel;
    private Double driverLatitude;
    private Double driverLongitude;

    // Ride verification OTP (revealed only when driver assigned/arrived)
    private String otp;
    private LocalDateTime otpExpiresAt;

    private String message;
    private LocalDateTime createdAt;
}

