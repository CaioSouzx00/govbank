package com.govbank.api.model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "transacao")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class Transacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_beneficio", nullable = false)
    private Beneficio beneficio;

    @Column(name = "agencia_dest", length = 4, nullable = false)
    private String agenciaDest;

    @Column(name = "conta_dest", length = 15, nullable = false)
    private String contaDest;

    @Column(name = "cod_banco_dest", length = 3, nullable = false)
    private String codBancoDest;

    @Column(name = "valor", precision = 15, scale = 2, nullable = false)
    private BigDecimal valor;

    @Column(name = "data_hora")
    private LocalDateTime dataHora = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 15)
    private StatusTransacao status = StatusTransacao.PENDENTE;

    @Column(name = "hash_auditoria", length = 64, nullable = false)
    private String hashAuditoria;

    @Column(name = "cod_retorno_banco", length = 10)
    private String codRetornoBanco;

    public enum StatusTransacao {
        PENDENTE, PROCESSANDO, CONCLUIDA, ERRO, ESTORNADA
    }
}