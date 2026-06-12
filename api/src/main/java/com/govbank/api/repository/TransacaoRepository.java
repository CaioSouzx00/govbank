package com.govbank.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.govbank.api.model.entity.Transacao;

@Repository
public interface TransacaoRepository extends JpaRepository<Transacao, Long> {
    List<Transacao> findByBeneficioId(Integer beneficioId);
    List<Transacao> findByStatus(Transacao.StatusTransacao status);
}