package com.metersay.metersay_backend.controller;

import com.metersay.metersay_backend.dto.UserProfileResponse;
import com.metersay.metersay_backend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/customer")
@RequiredArgsConstructor
public class CustomerController {

    private final UserService userService;

    @GetMapping("/profile")
    public ResponseEntity<UserProfileResponse> getCustomerProfile(Authentication authentication) {
        String phoneNumber = authentication.getName();
        UserProfileResponse profile = userService.getProfile(phoneNumber);
        return ResponseEntity.ok(profile);
    }
}

