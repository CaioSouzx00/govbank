package com.govbank.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.govbank.api.model.entity.BancoConveniado;

@Repository
public interface BancoConviadoRepository extends JpaRepository<BancoConveniado, String> {
    List<BancoConveniado> findByStatusConvenioTrue();
}