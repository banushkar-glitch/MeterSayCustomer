package com.metersay.metersay_backend.repository;

import com.metersay.metersay_backend.model.Role;
import com.metersay.metersay_backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByPhoneNumber(String phoneNumber);
    boolean existsByPhoneNumber(String phoneNumber);
    List<User> findByRoleAndIsAvailableTrue(Role role);
}

