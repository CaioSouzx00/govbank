package com.govbank.api.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govbank.api.exception.ResourceNotFoundException;
import com.govbank.api.model.entity.Transacao;
import com.govbank.api.repository.TransacaoRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TransacaoService {

    private final TransacaoRepository transacaoRepository;

    @Transactional(readOnly = true)
    public List<Transacao> listarPorBeneficio(Integer beneficioId) {
        log.info("Buscando transações do benefício ID: {}", beneficioId);
        return transacaoRepository.findByBeneficioId(beneficioId);
    }

    @Transactional(readOnly = true)
    public List<Transacao> listarPorStatus(Transacao.StatusTransacao status) {
        log.info("Buscando transações com status: {}", status);
        return transacaoRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public List<Transacao> listarTodas() {
        log.info("Listando todas as transações");
        return transacaoRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Transacao buscarPorId(Long id) {
        log.info("Buscando transação ID: {}", id);
        return transacaoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Transação não encontrada com ID: " + id));
    }
}
