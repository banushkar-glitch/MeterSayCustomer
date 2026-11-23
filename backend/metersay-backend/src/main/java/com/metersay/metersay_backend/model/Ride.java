package com.metersay.metersay_backend.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "rides")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ride {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private User customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "driver_id")
    private User driver;

    @Column(name = "pickup_address", nullable = false, length = 255)
    private String pickupAddress;

    @Column(name = "pickup_latitude", nullable = false)
    private Double pickupLatitude;

    @Column(name = "pickup_longitude", nullable = false)
    private Double pickupLongitude;

    @Column(name = "drop_address", nullable = false, length = 255)
    private String dropAddress;

    @Column(name = "drop_latitude", nullable = false)
    private Double dropLatitude;

    @Column(name = "drop_longitude", nullable = false)
    private Double dropLongitude;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    @Builder.Default
    private RideStatus status = RideStatus.SEARCHING_DRIVER;

    @Column(name = "otp", length = 10)
    private String otp;

    @Column(name = "otp_hash", length = 100)
    private String otpHash;

    @Column(name = "otp_expires_at")
    private LocalDateTime otpExpiresAt;

    @Column(name = "pickup_lat")
    private BigDecimal pickupLat;

    @Column(name = "pickup_lng")
    private BigDecimal pickupLng;

    @Column(name = "drop_lat")
    private BigDecimal dropLat;

    @Column(name = "drop_lng")
    private BigDecimal dropLng;

    @Column(name = "distance_km")
    private BigDecimal distanceKm;

    @Column(name = "fare")
    private BigDecimal fare;

    @Column(name = "ride_type")
    private String rideType;

    @Column(name = "search_radius_meters")
    @Builder.Default
    private Double searchRadiusMeters = 500.0;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "rating")
    private Integer rating;

    @Column(name = "review", length = 500)
    private String review;

    @Column(name = "cancellation_reason", length = 255)
    private String cancellationReason;

    @Column(name = "cancelled_at")
    private LocalDateTime cancelledAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.status == null) {
            this.status = RideStatus.SEARCHING_DRIVER;
        }
        if (this.searchRadiusMeters == null) {
            this.searchRadiusMeters = 500.0;
        }
        if (this.pickupLatitude != null && this.pickupLat == null) {
            this.pickupLat = BigDecimal.valueOf(this.pickupLatitude);
        }
        if (this.pickupLongitude != null && this.pickupLng == null) {
            this.pickupLng = BigDecimal.valueOf(this.pickupLongitude);
        }
        if (this.dropLatitude != null && this.dropLat == null) {
            this.dropLat = BigDecimal.valueOf(this.dropLatitude);
        }
        if (this.dropLongitude != null && this.dropLng == null) {
            this.dropLng = BigDecimal.valueOf(this.dropLongitude);
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}

