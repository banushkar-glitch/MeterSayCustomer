package com.metersay.metersay_backend.controller;

import com.metersay.metersay_backend.dto.BookRideRequest;
import com.metersay.metersay_backend.dto.BookRideResponse;
import com.metersay.metersay_backend.dto.RideDetailsResponse;
import com.metersay.metersay_backend.service.RideService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/rides")
@RequiredArgsConstructor
public class RideController {

    private final RideService rideService;

    @PostMapping("/book")
    public ResponseEntity<BookRideResponse> bookRide(
            @Valid @RequestBody BookRideRequest request,
            Authentication authentication) {
        String phoneNumber = authentication.getName();
        BookRideResponse response = rideService.bookRide(phoneNumber, request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping("/{rideId}")
    public ResponseEntity<RideDetailsResponse> getRideDetails(
            @PathVariable Long rideId,
            Authentication authentication) {
        String phoneNumber = authentication.getName();
        RideDetailsResponse response = rideService.getRideDetails(rideId, phoneNumber);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/active")
    public ResponseEntity<RideDetailsResponse> getActiveRide(Authentication authentication) {
        String phoneNumber = authentication.getName();
        RideDetailsResponse response = rideService.getActiveRide(phoneNumber);
        if (response == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{rideId}/cancel")
    public ResponseEntity<RideDetailsResponse> cancelRide(
            @PathVariable Long rideId,
            Authentication authentication) {
        String phoneNumber = authentication.getName();
        RideDetailsResponse response = rideService.cancelRide(rideId, phoneNumber);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{rideId}/assign-driver")
    public ResponseEntity<RideDetailsResponse> assignDriver(
            @PathVariable Long rideId,
            @RequestParam Long driverId) {
        RideDetailsResponse response = rideService.assignDriver(rideId, driverId);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{rideId}/driver-arrived")
    public ResponseEntity<RideDetailsResponse> driverArrived(@PathVariable Long rideId) {
        RideDetailsResponse response = rideService.driverArrived(rideId);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{rideId}/verify-otp")
    public ResponseEntity<RideDetailsResponse> verifyOtp(
            @PathVariable Long rideId,
            @RequestParam String otp) {
        RideDetailsResponse response = rideService.verifyOtpAndStartRide(rideId, otp);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{rideId}/complete-ride")
    public ResponseEntity<RideDetailsResponse> completeRide(@PathVariable Long rideId) {
        RideDetailsResponse response = rideService.completeRide(rideId);
        return ResponseEntity.ok(response);
    }
}

