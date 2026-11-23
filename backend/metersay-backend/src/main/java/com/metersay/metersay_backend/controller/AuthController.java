package com.metersay.metersay_backend.controller;

import com.metersay.metersay_backend.dto.AuthResponse;
import com.metersay.metersay_backend.dto.LoginRequest;
import com.metersay.metersay_backend.dto.RegisterRequest;
import com.metersay.metersay_backend.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reset-password")
    public ResponseEntity<java.util.Map<String, String>> resetPassword(@RequestBody java.util.Map<String, String> request) {
        String phone = request.get("phoneNumber");
        String newPassword = request.get("newPassword");
        if (phone == null || newPassword == null || phone.trim().isEmpty() || newPassword.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(java.util.Map.of("message", "Phone number and new password are required"));
        }
        authService.resetPassword(phone, newPassword);
        return ResponseEntity.ok(java.util.Map.of("message", "Password updated successfully"));
    }
}

