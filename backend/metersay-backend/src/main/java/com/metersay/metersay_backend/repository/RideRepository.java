package com.metersay.metersay_backend.repository;

import com.metersay.metersay_backend.model.Ride;
import com.metersay.metersay_backend.model.RideStatus;
import com.metersay.metersay_backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RideRepository extends JpaRepository<Ride, Long> {
    List<Ride> findByCustomerOrderByCreatedAtDesc(User customer);

    Optional<Ride> findFirstByCustomerAndStatusInOrderByCreatedAtDesc(User customer, List<RideStatus> statuses);

    Optional<Ride> findByIdAndCustomer(Long id, User customer);
}

