package com.metersay.metersay_backend.service;

import com.metersay.metersay_backend.dto.BookRideRequest;
import com.metersay.metersay_backend.dto.BookRideResponse;
import com.metersay.metersay_backend.dto.RideDetailsResponse;
import com.metersay.metersay_backend.exception.BadRequestException;
import com.metersay.metersay_backend.exception.ResourceNotFoundException;
import com.metersay.metersay_backend.model.Ride;
import com.metersay.metersay_backend.model.RideStatus;
import com.metersay.metersay_backend.model.Role;
import com.metersay.metersay_backend.model.User;
import com.metersay.metersay_backend.repository.RideRepository;
import com.metersay.metersay_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class RideService {

    private final RideRepository rideRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final SecureRandom secureRandom = new SecureRandom();

    // Two-stage Driver Search System
    public static final double INITIAL_SEARCH_RADIUS_METERS = 500.0; // Stage 1: 500 meters
    public static final double EXPANDED_SEARCH_RADIUS_METERS = 1000.0; // Stage 2: 1000 meters (1 km)
    private static final int STAGE1_TIMEOUT_SECONDS = 15; // 15 seconds before auto-expansion

    private void ensureSeedDriversExist() {
        long driverCount = userRepository.countByRole(Role.DRIVER);
        if (driverCount == 0) {
            log.info("No drivers found in database. Initializing seed auto rickshaw drivers...");
            List<User> seedDrivers = List.of(
                User.builder()
                    .name("Mahesh Jagtap")
                    .phoneNumber("9876543210")
                    .password(passwordEncoder.encode("driver123"))
                    .role(Role.DRIVER)
                    .isAvailable(true)
                    .autoNumber("MH 12 AA 1234")
                    .autoModel("Bajaj Compact RE")
                    .currentLatitude(18.4575)
                    .currentLongitude(73.8050)
                    .build(),
                User.builder()
                    .name("Ramesh Shinde")
                    .phoneNumber("9876543211")
                    .password(passwordEncoder.encode("driver123"))
                    .role(Role.DRIVER)
                    .isAvailable(true)
                    .autoNumber("MH 12 AB 5678")
                    .autoModel("Piaggio Ape City")
                    .currentLatitude(18.4600)
                    .currentLongitude(73.8080)
                    .build(),
                User.builder()
                    .name("Suresh Patil")
                    .phoneNumber("9876543212")
                    .password(passwordEncoder.encode("driver123"))
                    .role(Role.DRIVER)
                    .isAvailable(true)
                    .autoNumber("MH 12 BC 9012")
                    .autoModel("TVS King Deluxe")
                    .currentLatitude(18.4550)
                    .currentLongitude(73.8020)
                    .build()
            );
            userRepository.saveAll(seedDrivers);
            log.info("Initialized {} seed auto drivers.", seedDrivers.size());
        }
    }

    @Transactional
    public BookRideResponse bookRide(String customerPhoneNumber, BookRideRequest request) {
        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        // Check if customer already has an active ride
        List<RideStatus> activeStatuses = Arrays.asList(
                RideStatus.SEARCHING_DRIVER,
                RideStatus.DRIVER_ASSIGNED,
                RideStatus.DRIVER_ARRIVING,
                RideStatus.DRIVER_ARRIVED,
                RideStatus.RIDE_STARTED
        );

        rideRepository.findFirstByCustomerAndStatusInOrderByCreatedAtDesc(customer, activeStatuses)
                .ifPresent(existingRide -> {
                    throw new BadRequestException("You already have an active ride (ID: " + existingRide.getId() + ") in status: " + existingRide.getStatus());
                });

        ensureSeedDriversExist();

        // Two-Stage Driver Search Logic:
        // Stage 1: Search available drivers within 500 meters
        List<User> availableDrivers = userRepository.findByRoleAndIsAvailableTrue(Role.DRIVER);
        List<User> driversWithin500m = new ArrayList<>();
        List<User> driversWithin1Km = new ArrayList<>();

        for (User driver : availableDrivers) {
            if (driver.getCurrentLatitude() != null && driver.getCurrentLongitude() != null) {
                double distance = calculateDistanceMeters(
                        request.getPickupLatitude(),
                        request.getPickupLongitude(),
                        driver.getCurrentLatitude(),
                        driver.getCurrentLongitude()
                );
                if (distance <= INITIAL_SEARCH_RADIUS_METERS) {
                    driversWithin500m.add(driver);
                }
                if (distance <= EXPANDED_SEARCH_RADIUS_METERS) {
                    driversWithin1Km.add(driver);
                }
            }
        }

        double searchRadius;
        int nearbyDriversCount;
        String message;

        if (!driversWithin500m.isEmpty()) {
            // Stage 1: Eligible driver(s) found within 500 meters
            searchRadius = INITIAL_SEARCH_RADIUS_METERS;
            nearbyDriversCount = driversWithin500m.size();
            message = "Ride booked successfully! Request broadcast to " + nearbyDriversCount + " nearby driver(s) within 500m.";
            log.info("Stage 1 (500m): Found {} available drivers within 500m for pickup ({}, {})",
                    nearbyDriversCount, request.getPickupLatitude(), request.getPickupLongitude());
        } else {
            // Stage 2: No drivers within 500m, automatically expand to 1000m (1 km)
            searchRadius = EXPANDED_SEARCH_RADIUS_METERS;
            nearbyDriversCount = driversWithin1Km.size();
            message = nearbyDriversCount > 0
                    ? "No drivers within 500m. Search automatically expanded to 1 km: broadcast to " + nearbyDriversCount + " driver(s)."
                    : "No nearby auto drivers available within 1 km. Please try again later.";
            log.info("Stage 2 (Expanded 1km): Found {} available drivers within 1 km for pickup ({}, {})",
                    nearbyDriversCount, request.getPickupLatitude(), request.getPickupLongitude());
        }

        double distanceMeters = calculateDistanceMeters(
                request.getPickupLatitude(),
                request.getPickupLongitude(),
                request.getDropLatitude(),
                request.getDropLongitude()
        );
        double distKm = distanceMeters / 1000.0;
        double estimatedFare = Math.max(25.0, 25.0 + Math.max(0, distKm - 1.5) * 15.0);

        Ride ride = Ride.builder()
                .customer(customer)
                .pickupAddress(request.getPickupAddress())
                .pickupLatitude(request.getPickupLatitude())
                .pickupLongitude(request.getPickupLongitude())
                .dropAddress(request.getDropAddress())
                .dropLatitude(request.getDropLatitude())
                .dropLongitude(request.getDropLongitude())
                .pickupLat(BigDecimal.valueOf(request.getPickupLatitude()))
                .pickupLng(BigDecimal.valueOf(request.getPickupLongitude()))
                .dropLat(BigDecimal.valueOf(request.getDropLatitude()))
                .dropLng(BigDecimal.valueOf(request.getDropLongitude()))
                .distanceKm(BigDecimal.valueOf(Math.round(distKm * 10.0) / 10.0))
                .fare(BigDecimal.valueOf(Math.round(estimatedFare)))
                .rideType("auto")
                .searchRadiusMeters(searchRadius)
                .status(RideStatus.SEARCHING_DRIVER)
                .build();

        Ride savedRide = rideRepository.save(ride);

        return BookRideResponse.builder()
                .rideId(savedRide.getId())
                .status(savedRide.getStatus())
                .pickupAddress(savedRide.getPickupAddress())
                .pickupLatitude(savedRide.getPickupLatitude())
                .pickupLongitude(savedRide.getPickupLongitude())
                .dropAddress(savedRide.getDropAddress())
                .dropLatitude(savedRide.getDropLatitude())
                .dropLongitude(savedRide.getDropLongitude())
                .searchRadiusMeters(searchRadius)
                .nearbyDriversCount(nearbyDriversCount)
                .message(message)
                .createdAt(savedRide.getCreatedAt())
                .build();
    }

    private void checkAndExpandSearchRadiusIfNeeded(Ride ride) {
        if (ride.getStatus() == RideStatus.SEARCHING_DRIVER &&
                ride.getSearchRadiusMeters() != null &&
                ride.getSearchRadiusMeters() <= INITIAL_SEARCH_RADIUS_METERS) {

            // If searching for more than STAGE1_TIMEOUT_SECONDS (15s) without a driver accepting
            if (ride.getCreatedAt() != null &&
                    ride.getCreatedAt().plusSeconds(STAGE1_TIMEOUT_SECONDS).isBefore(LocalDateTime.now())) {
                ride.setSearchRadiusMeters(EXPANDED_SEARCH_RADIUS_METERS);
                rideRepository.save(ride);
                log.info("Ride {} search radius automatically expanded from 500m to 1 km after {}s without driver acceptance.",
                        ride.getId(), STAGE1_TIMEOUT_SECONDS);
            }
        }
    }

    @Transactional
    public RideDetailsResponse getRideDetails(Long rideId, String customerPhoneNumber) {
        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        Ride ride = rideRepository.findByIdAndCustomer(rideId, customer)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        checkAndExpandSearchRadiusIfNeeded(ride);

        return mapToDetailsResponse(ride);
    }

    @Transactional
    public RideDetailsResponse getActiveRide(String customerPhoneNumber) {
        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        List<RideStatus> activeStatuses = Arrays.asList(
                RideStatus.SEARCHING_DRIVER,
                RideStatus.DRIVER_ASSIGNED,
                RideStatus.DRIVER_ARRIVING,
                RideStatus.DRIVER_ARRIVED,
                RideStatus.RIDE_STARTED
        );

        return rideRepository.findFirstByCustomerAndStatusInOrderByCreatedAtDesc(customer, activeStatuses)
                .map(ride -> {
                    checkAndExpandSearchRadiusIfNeeded(ride);
                    return mapToDetailsResponse(ride);
                })
                .orElse(null);
    }

    @Transactional
    public RideDetailsResponse cancelRide(Long rideId, String customerPhoneNumber) {
        return cancelRide(rideId, customerPhoneNumber, "Cancelled by Customer");
    }

    @Transactional
    public RideDetailsResponse cancelRide(Long rideId, String customerPhoneNumber, String reason) {
        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        Ride ride = rideRepository.findByIdAndCustomer(rideId, customer)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        if (ride.getStatus() == RideStatus.RIDE_COMPLETED || ride.getStatus() == RideStatus.CANCELLED) {
            throw new BadRequestException("Ride is already " + ride.getStatus());
        }

        ride.setStatus(RideStatus.CANCELLED);
        ride.setCancellationReason(reason != null && !reason.trim().isEmpty() ? reason.trim() : "Cancelled by Customer");
        ride.setCancelledAt(LocalDateTime.now());

        if (ride.getDriver() != null) {
            User driver = ride.getDriver();
            driver.setIsAvailable(true);
            userRepository.save(driver);
        }

        Ride updatedRide = rideRepository.save(ride);
        log.info("Ride {} successfully cancelled in database. Customer: {}, Reason: {}",
                rideId, customerPhoneNumber, ride.getCancellationReason());

        return mapToDetailsResponse(updatedRide);
    }

    @Transactional
    public RideDetailsResponse assignDriver(Long rideId, Long driverId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        if (ride.getStatus() != RideStatus.SEARCHING_DRIVER) {
            throw new BadRequestException("Ride is not in SEARCHING_DRIVER status. Current status: " + ride.getStatus());
        }

        User driver = userRepository.findById(driverId)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found with id: " + driverId));

        if (driver.getRole() != Role.DRIVER) {
            throw new BadRequestException("User with id " + driverId + " is not a DRIVER");
        }

        // Verify driver is within active search radius (500m or 1000m)
        if (driver.getCurrentLatitude() != null && driver.getCurrentLongitude() != null) {
            double distance = calculateDistanceMeters(
                    ride.getPickupLatitude(),
                    ride.getPickupLongitude(),
                    driver.getCurrentLatitude(),
                    driver.getCurrentLongitude()
            );
            double allowedRadius = ride.getSearchRadiusMeters() != null
                    ? ride.getSearchRadiusMeters()
                    : EXPANDED_SEARCH_RADIUS_METERS;
            if (distance > allowedRadius) {
                throw new BadRequestException("Driver is outside active search radius (" + Math.round(distance) + "m away, current limit: " + Math.round(allowedRadius) + "m)");
            }
        }

        ride.setDriver(driver);
        ride.setStatus(RideStatus.DRIVER_ASSIGNED);

        // Mark driver unavailable while on assigned ride
        driver.setIsAvailable(false);
        userRepository.save(driver);

        // Dynamic 4-digit OTP generated securely by Spring Boot backend
        String plainOtp = String.valueOf(1000 + secureRandom.nextInt(9000));
        ride.setOtp(plainOtp);
        ride.setOtpHash(passwordEncoder.encode(plainOtp));
        ride.setOtpExpiresAt(LocalDateTime.now().plusMinutes(15));

        Ride updatedRide = rideRepository.save(ride);

        log.info("Driver {} (ID: {}) assigned to ride {}. Dynamic 4-digit OTP generated: {}", driver.getName(), driver.getId(), ride.getId(), plainOtp);
        return mapToDetailsResponse(updatedRide);
    }

    @Transactional
    public RideDetailsResponse driverArrived(Long rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        if (ride.getStatus() != RideStatus.DRIVER_ASSIGNED && ride.getStatus() != RideStatus.DRIVER_ARRIVING) {
            throw new BadRequestException("Cannot set DRIVER_ARRIVED for ride in status: " + ride.getStatus());
        }

        ride.setStatus(RideStatus.DRIVER_ARRIVED);
        Ride updatedRide = rideRepository.save(ride);

        log.info("Driver arrived for ride {}", ride.getId());
        return mapToDetailsResponse(updatedRide);
    }

    @Transactional
    public RideDetailsResponse verifyOtpAndStartRide(Long rideId, String otpInput) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        if (ride.getStatus() != RideStatus.DRIVER_ARRIVED && ride.getStatus() != RideStatus.DRIVER_ASSIGNED) {
            throw new BadRequestException("Ride is not ready to start. Status: " + ride.getStatus());
        }

        if (ride.getOtpExpiresAt() != null && LocalDateTime.now().isAfter(ride.getOtpExpiresAt())) {
            throw new BadRequestException("OTP has expired. Please request a new OTP.");
        }

        String input = otpInput != null ? otpInput.trim() : "";
        boolean matches = false;
        if (ride.getOtpHash() != null && passwordEncoder.matches(input, ride.getOtpHash())) {
            matches = true;
        } else if (ride.getOtp() != null && ride.getOtp().trim().equals(input)) {
            matches = true;
        }

        if (!matches) {
            throw new BadRequestException("Invalid OTP. Verification failed.");
        }

        // Clear plain OTP to prevent replay/reuse
        ride.setOtp(null);
        ride.setStatus(RideStatus.RIDE_STARTED);
        Ride updatedRide = rideRepository.save(ride);

        log.info("4-digit OTP verified successfully for ride {}. Ride started.", ride.getId());
        return mapToDetailsResponse(updatedRide);
    }

    @Transactional
    public RideDetailsResponse completeRide(Long rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        if (ride.getStatus() != RideStatus.RIDE_STARTED) {
            throw new BadRequestException("Ride is not in progress. Current status: " + ride.getStatus());
        }

        ride.setStatus(RideStatus.RIDE_COMPLETED);
        ride.setCompletedAt(LocalDateTime.now());
        if (ride.getDriver() != null) {
            User driver = ride.getDriver();
            driver.setIsAvailable(true);
            userRepository.save(driver);
        }
        Ride updatedRide = rideRepository.save(ride);

        log.info("Ride {} completed successfully. Driver marked available for new rides.", ride.getId());
        return mapToDetailsResponse(updatedRide);
    }

    @Transactional
    public RideDetailsResponse rateRide(Long rideId, String customerPhoneNumber, Integer rating, String review) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        if (!ride.getCustomer().getId().equals(customer.getId())) {
            throw new BadRequestException("You are not authorized to rate this ride.");
        }

        if (ride.getStatus() != RideStatus.RIDE_COMPLETED) {
            throw new BadRequestException("Cannot rate ride that is not completed. Current status: " + ride.getStatus());
        }

        if (rating == null || rating < 1 || rating > 5) {
            throw new BadRequestException("Rating must be between 1 and 5.");
        }

        ride.setRating(rating);
        if (review != null && !review.trim().isEmpty()) {
            ride.setReview(review.trim());
        }

        Ride updatedRide = rideRepository.save(ride);
        log.info("Customer {} submitted rating ({}/5) for ride {}", customerPhoneNumber, rating, ride.getId());
        return mapToDetailsResponse(updatedRide);
    }

    public RideDetailsResponse mapToDetailsResponse(Ride ride) {
        RideDetailsResponse.RideDetailsResponseBuilder builder = RideDetailsResponse.builder()
                .rideId(ride.getId())
                .status(ride.getStatus())
                .pickupAddress(ride.getPickupAddress())
                .pickupLatitude(ride.getPickupLatitude())
                .pickupLongitude(ride.getPickupLongitude())
                .dropAddress(ride.getDropAddress())
                .dropLatitude(ride.getDropLatitude())
                .dropLongitude(ride.getDropLongitude())
                .searchRadiusMeters(ride.getSearchRadiusMeters() != null ? ride.getSearchRadiusMeters() : INITIAL_SEARCH_RADIUS_METERS)
                .message(ride.getStatus() == RideStatus.CANCELLED
                        ? "Ride Cancelled: " + (ride.getCancellationReason() != null ? ride.getCancellationReason() : "Cancelled")
                        : "Status: " + ride.getStatus().name())
                .rating(ride.getRating())
                .review(ride.getReview())
                .completedAt(ride.getCompletedAt())
                .cancellationReason(ride.getCancellationReason())
                .cancelledAt(ride.getCancelledAt())
                .createdAt(ride.getCreatedAt());

        if (ride.getDriver() != null) {
            User driver = ride.getDriver();
            builder.driverId(driver.getId())
                    .driverName(driver.getName())
                    .driverPhoneNumber(driver.getPhoneNumber())
                    .autoNumber(driver.getAutoNumber())
                    .autoModel(driver.getAutoModel())
                    .driverLatitude(driver.getCurrentLatitude())
                    .driverLongitude(driver.getCurrentLongitude());
        }

        // Reveal OTP only when driver is assigned or arrived
        if (ride.getStatus() == RideStatus.DRIVER_ASSIGNED ||
            ride.getStatus() == RideStatus.DRIVER_ARRIVING ||
            ride.getStatus() == RideStatus.DRIVER_ARRIVED) {
            builder.otp(ride.getOtp());
            builder.otpExpiresAt(ride.getOtpExpiresAt());
        }

        return builder.build();
    }

    /**
     * Calculates distance between two points in meters using Haversine formula
     */
    public double calculateDistanceMeters(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371000; // Radius of Earth in meters
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}

