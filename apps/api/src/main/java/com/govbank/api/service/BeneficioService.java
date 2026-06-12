package com.govbank.api.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govbank.api.model.entity.Beneficio;
import com.govbank.api.repository.BeneficioRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BeneficioService {

    private final BeneficioRepository beneficioRepository;

    @Transactional(readOnly = true)
    public List<Beneficio> listarPorCpf(String cpf) {
        log.info("Buscando benefícios do cidadão CPF: {}", cpf);
        return beneficioRepository.findByCidadaoCpf(cpf);
    }

    @Transactional(readOnly = true)
    public List<Beneficio> listarPorStatus(Beneficio.StatusBeneficio status) {
        log.info("Buscando benefícios com status: {}", status);
        return beneficioRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public List<Beneficio> listarTodos() {
        log.info("Listando todos os benefícios");
        return beneficioRepository.findAll();
    }
}