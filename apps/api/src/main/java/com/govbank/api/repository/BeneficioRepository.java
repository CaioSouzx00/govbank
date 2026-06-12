package com.govbank.api.repository;

import com.govbank.api.model.entity.Beneficio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BeneficioRepository extends JpaRepository<Beneficio, Integer> {
    
    List<Beneficio> findByCidadaoCpf(String cpf);
    
    List<Beneficio> findByStatus(Beneficio.StatusBeneficio status);
}
