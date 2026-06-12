package com.govbank.api.repository;

import com.govbank.api.model.entity.Cidadao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CidadaoRepository extends JpaRepository<Cidadao, String> {
    
    List<Cidadao> findByStatus(Cidadao.StatusCidadao status);
    
    boolean existsByCpf(String cpf);
}
