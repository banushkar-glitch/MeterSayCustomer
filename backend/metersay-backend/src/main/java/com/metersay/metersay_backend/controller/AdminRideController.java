package com.metersay.metersay_backend.controller;

import com.metersay.metersay_backend.dto.RideDetailsResponse;
import com.metersay.metersay_backend.model.Ride;
import com.metersay.metersay_backend.model.RideStatus;
import com.metersay.metersay_backend.repository.RideRepository;
import com.metersay.metersay_backend.service.RideService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminRideController {

    private final RideRepository rideRepository;
    private final RideService rideService;

    /**
     * Get all rides in the database with optional status filter (e.g. status=CANCELLED)
     */
    @GetMapping("/rides")
    public ResponseEntity<List<RideDetailsResponse>> getAllRides(
            @RequestParam(required = false) RideStatus status) {
        List<Ride> rides = (status != null)
                ? rideRepository.findByStatusOrderByCreatedAtDesc(status)
                : rideRepository.findAllByOrderByCreatedAtDesc();

        List<RideDetailsResponse> response = rides.stream()
                .map(rideService::mapToDetailsResponse)
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    /**
     * Get all cancelled rides with cancellation reason and timestamp
     */
    @GetMapping("/rides/cancelled")
    public ResponseEntity<List<RideDetailsResponse>> getCancelledRides() {
        List<Ride> cancelledRides = rideRepository.findByStatusOrderByCreatedAtDesc(RideStatus.CANCELLED);
        List<RideDetailsResponse> response = cancelledRides.stream()
                .map(rideService::mapToDetailsResponse)
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    /**
     * Get database statistics for admin dashboard
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalRides", rideRepository.count());
        stats.put("cancelledRides", rideRepository.countByStatus(RideStatus.CANCELLED));
        stats.put("completedRides", rideRepository.countByStatus(RideStatus.RIDE_COMPLETED));
        stats.put("searchingDriverRides", rideRepository.countByStatus(RideStatus.SEARCHING_DRIVER));
        stats.put("inProgressRides", rideRepository.countByStatus(RideStatus.RIDE_STARTED));

        return ResponseEntity.ok(stats);
    }
}

