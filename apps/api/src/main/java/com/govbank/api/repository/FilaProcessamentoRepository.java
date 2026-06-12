package com.govbank.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.govbank.api.model.entity.FilaProcessamento;

@Repository
public interface FilaProcessamentoRepository extends JpaRepository<FilaProcessamento, Long> {
    List<FilaProcessamento> findByStatus(FilaProcessamento.StatusFila status);
    List<FilaProcessamento> findByTipoOperacao(FilaProcessamento.TipoOperacao tipoOperacao);
}