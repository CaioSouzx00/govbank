package com.govbank.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.govbank.api.model.entity.ContaBancaria;
import com.govbank.api.model.entity.ContaBancariaId;

@Repository
public interface ContaBancariaRepository extends JpaRepository<ContaBancaria, ContaBancariaId> {
    List<ContaBancaria> findByTitularCpf(String cpf);
    List<ContaBancaria> findByCodBanco(String codBanco);
}