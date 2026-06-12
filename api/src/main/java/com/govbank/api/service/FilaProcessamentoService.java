package com.govbank.api.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govbank.api.model.entity.FilaProcessamento;
import com.govbank.api.repository.FilaProcessamentoRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class FilaProcessamentoService {

    private final FilaProcessamentoRepository filaRepository;

    @Transactional
    public FilaProcessamento enfileirar(FilaProcessamento.TipoOperacao tipoOperacao,
                                        Long idReferencia,
                                        Map<String, Object> payload) {
        log.info("Enfileirando operação: {} para referência: {}", tipoOperacao, idReferencia);

        FilaProcessamento item = FilaProcessamento.builder()
                .tipoOperacao(tipoOperacao)
                .idReferencia(idReferencia)
                .payloadJson(payload)
                .status(FilaProcessamento.StatusFila.PENDENTE)
                .dataCriacao(LocalDateTime.now())
                .tentativas(0)
                .build();

        return filaRepository.save(item);
    }

    @Transactional(readOnly = true)
    public List<FilaProcessamento> listarPendentes() {
        log.info("Listando itens pendentes na fila");
        return filaRepository.findByStatus(FilaProcessamento.StatusFila.PENDENTE);
    }

    @Transactional(readOnly = true)
    public List<FilaProcessamento> listarPorStatus(FilaProcessamento.StatusFila status) {
        log.info("Listando fila com status: {}", status);
        return filaRepository.findByStatus(status);
    }

    @Transactional
    public FilaProcessamento marcarComoProcessando(Long id) {
        FilaProcessamento item = filaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item de fila não encontrado: " + id));
        item.setStatus(FilaProcessamento.StatusFila.PROCESSANDO);
        return filaRepository.save(item);
    }

    @Transactional
    public FilaProcessamento marcarComoConcluido(Long id) {
        FilaProcessamento item = filaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item de fila não encontrado: " + id));
        item.setStatus(FilaProcessamento.StatusFila.CONCLUIDO);
        item.setDataProcessamento(LocalDateTime.now());
        return filaRepository.save(item);
    }

    @Transactional
    public FilaProcessamento marcarComoErro(Long id, String mensagemErro) {
        FilaProcessamento item = filaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item de fila não encontrado: " + id));
        item.setStatus(FilaProcessamento.StatusFila.ERRO);
        item.setMensagemErro(mensagemErro);
        item.setTentativas(item.getTentativas() + 1);
        item.setDataProcessamento(LocalDateTime.now());
        return filaRepository.save(item);
    }
}
