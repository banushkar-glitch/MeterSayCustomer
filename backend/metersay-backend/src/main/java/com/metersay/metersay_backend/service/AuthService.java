package com.metersay.metersay_backend.service;

import com.metersay.metersay_backend.dto.AuthResponse;
import com.metersay.metersay_backend.dto.LoginRequest;
import com.metersay.metersay_backend.dto.RegisterRequest;
import com.metersay.metersay_backend.model.Role;
import com.metersay.metersay_backend.model.User;
import com.metersay.metersay_backend.repository.UserRepository;
import com.metersay.metersay_backend.security.JwtUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String phone = request.getPhoneNumber().trim();

        if (userRepository.existsByPhoneNumber(phone)) {
            throw new IllegalArgumentException("Phone number is already registered!");
        }

        User user = User.builder()
                .name(request.getName().trim())
                .phoneNumber(phone)
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.CUSTOMER)
                .build();

        User savedUser = userRepository.save(user);

        Map<String, Object> claims = new HashMap<>();
        claims.put("role", savedUser.getRole().name());
        claims.put("name", savedUser.getName());
        claims.put("userId", savedUser.getId());

        String token = jwtUtils.generateToken(savedUser.getPhoneNumber(), claims);

        return AuthResponse.builder()
                .token(token)
                .id(savedUser.getId())
                .name(savedUser.getName())
                .phoneNumber(savedUser.getPhoneNumber())
                .role(savedUser.getRole().name())
                .message("Customer registered successfully")
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        String phone = request.getPhoneNumber().trim();

        User user = userRepository.findByPhoneNumber(phone)
                .orElseThrow(() -> new BadCredentialsException("Invalid phone number or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BadCredentialsException("Invalid phone number or password");
        }

        Map<String, Object> claims = new HashMap<>();
        claims.put("role", user.getRole().name());
        claims.put("name", user.getName());
        claims.put("userId", user.getId());

        String token = jwtUtils.generateToken(user.getPhoneNumber(), claims);

        return AuthResponse.builder()
                .token(token)
                .id(user.getId())
                .name(user.getName())
                .phoneNumber(user.getPhoneNumber())
                .role(user.getRole().name())
                .message("Login successful")
                .build();
    }
}

