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
public class BookRideResponse {

    private Long rideId;
    private RideStatus status;
    private String pickupAddress;
    private Double pickupLatitude;
    private Double pickupLongitude;
    private String dropAddress;
    private Double dropLatitude;
    private Double dropLongitude;
    private int nearbyDriversCount;
    private String message;
    private LocalDateTime createdAt;
}

