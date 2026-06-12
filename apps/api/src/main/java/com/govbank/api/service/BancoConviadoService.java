package com.govbank.api.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govbank.api.exception.ResourceNotFoundException;
import com.govbank.api.model.entity.BancoConveniado;
import com.govbank.api.repository.BancoConviadoRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BancoConviadoService {

    private final BancoConviadoRepository repository;

    @Transactional(readOnly = true)
    public List<BancoConveniado> listarAtivos() {
        return repository.findByStatusConvenioTrue();
    }

    @Transactional(readOnly = true)
    public List<BancoConveniado> listarTodos() {
        return repository.findAll();
    }

    @Transactional(readOnly = true)
    public BancoConveniado buscarPorCodigo(String codBanco) {
        return repository.findById(codBanco)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Banco não encontrado com código: " + codBanco));
    }
}