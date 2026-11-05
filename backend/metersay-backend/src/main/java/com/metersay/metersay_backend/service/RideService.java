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

import java.security.SecureRandom;
import java.time.LocalDateTime;
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

    // Strict 1 KM restriction (1000 meters)
    private static final double MAX_DRIVER_SEARCH_RADIUS_METERS = 1000.0;

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

        // 1 KM Driver Search Rule:
        // Find available drivers within 1000 meters from customer's pickup coordinates
        List<User> availableDrivers = userRepository.findByRoleAndIsAvailableTrue(Role.DRIVER);
        int nearbyDriversCount = 0;
        for (User driver : availableDrivers) {
            if (driver.getCurrentLatitude() != null && driver.getCurrentLongitude() != null) {
                double distance = calculateDistanceMeters(
                        request.getPickupLatitude(),
                        request.getPickupLongitude(),
                        driver.getCurrentLatitude(),
                        driver.getCurrentLongitude()
                );
                if (distance <= MAX_DRIVER_SEARCH_RADIUS_METERS) {
                    nearbyDriversCount++;
                }
            }
        }

        log.info("Found {} available drivers within 1 km for pickup ({}, {})",
                nearbyDriversCount, request.getPickupLatitude(), request.getPickupLongitude());

        Ride ride = Ride.builder()
                .customer(customer)
                .pickupAddress(request.getPickupAddress())
                .pickupLatitude(request.getPickupLatitude())
                .pickupLongitude(request.getPickupLongitude())
                .dropAddress(request.getDropAddress())
                .dropLatitude(request.getDropLatitude())
                .dropLongitude(request.getDropLongitude())
                .status(RideStatus.SEARCHING_DRIVER)
                .build();

        Ride savedRide = rideRepository.save(ride);

        String message = nearbyDriversCount > 0
                ? "Ride booked successfully! Searching for nearby auto drivers within 1 km."
                : "No nearby auto drivers available. Please try again later.";

        return BookRideResponse.builder()
                .rideId(savedRide.getId())
                .status(savedRide.getStatus())
                .pickupAddress(savedRide.getPickupAddress())
                .pickupLatitude(savedRide.getPickupLatitude())
                .pickupLongitude(savedRide.getPickupLongitude())
                .dropAddress(savedRide.getDropAddress())
                .dropLatitude(savedRide.getDropLatitude())
                .dropLongitude(savedRide.getDropLongitude())
                .nearbyDriversCount(nearbyDriversCount)
                .message(message)
                .createdAt(savedRide.getCreatedAt())
                .build();
    }

    @Transactional(readOnly = true)
    public RideDetailsResponse getRideDetails(Long rideId, String customerPhoneNumber) {
        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        Ride ride = rideRepository.findByIdAndCustomer(rideId, customer)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        return mapToDetailsResponse(ride);
    }

    @Transactional(readOnly = true)
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
                .map(this::mapToDetailsResponse)
                .orElse(null);
    }

    @Transactional
    public RideDetailsResponse cancelRide(Long rideId, String customerPhoneNumber) {
        User customer = userRepository.findByPhoneNumber(customerPhoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with phone: " + customerPhoneNumber));

        Ride ride = rideRepository.findByIdAndCustomer(rideId, customer)
                .orElseThrow(() -> new ResourceNotFoundException("Ride not found with id: " + rideId));

        if (ride.getStatus() == RideStatus.RIDE_COMPLETED || ride.getStatus() == RideStatus.CANCELLED) {
            throw new BadRequestException("Ride is already " + ride.getStatus());
        }

        ride.setStatus(RideStatus.CANCELLED);
        Ride updatedRide = rideRepository.save(ride);

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

        // Verify driver is within 1 km of pickup coordinates
        if (driver.getCurrentLatitude() != null && driver.getCurrentLongitude() != null) {
            double distance = calculateDistanceMeters(
                    ride.getPickupLatitude(),
                    ride.getPickupLongitude(),
                    driver.getCurrentLatitude(),
                    driver.getCurrentLongitude()
            );
            if (distance > MAX_DRIVER_SEARCH_RADIUS_METERS) {
                throw new BadRequestException("Driver is outside 1 km radius (" + Math.round(distance) + " meters away)");
            }
        }

        ride.setDriver(driver);
        ride.setStatus(RideStatus.DRIVER_ASSIGNED);

        // Dynamic 6-digit OTP generated securely by Spring Boot backend
        String plainOtp = String.valueOf(100000 + secureRandom.nextInt(900000));
        ride.setOtp(plainOtp);
        ride.setOtpHash(passwordEncoder.encode(plainOtp));
        ride.setOtpExpiresAt(LocalDateTime.now().plusMinutes(15));

        Ride updatedRide = rideRepository.save(ride);

        log.info("Driver {} (ID: {}) assigned to ride {}. Dynamic OTP generated.", driver.getName(), driver.getId(), ride.getId());
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

        if (ride.getOtpHash() == null || !passwordEncoder.matches(otpInput.trim(), ride.getOtpHash())) {
            throw new BadRequestException("Invalid OTP. Verification failed.");
        }

        // Clear plain OTP to prevent replay/reuse
        ride.setOtp(null);
        ride.setStatus(RideStatus.RIDE_STARTED);
        Ride updatedRide = rideRepository.save(ride);

        log.info("OTP verified successfully for ride {}. Ride started.", ride.getId());
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
        Ride updatedRide = rideRepository.save(ride);

        log.info("Ride {} completed successfully. Fare to be paid per physical meter.", ride.getId());
        return mapToDetailsResponse(updatedRide);
    }

    private RideDetailsResponse mapToDetailsResponse(Ride ride) {
        RideDetailsResponse.RideDetailsResponseBuilder builder = RideDetailsResponse.builder()
                .rideId(ride.getId())
                .status(ride.getStatus())
                .pickupAddress(ride.getPickupAddress())
                .pickupLatitude(ride.getPickupLatitude())
                .pickupLongitude(ride.getPickupLongitude())
                .dropAddress(ride.getDropAddress())
                .dropLatitude(ride.getDropLatitude())
                .dropLongitude(ride.getDropLongitude())
                .message("Status: " + ride.getStatus().name())
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

