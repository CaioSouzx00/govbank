package com.govbank.api.model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "conta_bancaria")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
@IdClass(ContaBancariaId.class)
public class ContaBancaria {

    @Id
    @Column(name = "agencia", length = 4)
    private String agencia;

    @Id
    @Column(name = "conta", length = 15)
    private String conta;

    @Id
    @Column(name = "cod_banco", length = 3)
    private String codBanco;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cpf_titular", nullable = false)
    private Cidadao titular;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cod_banco", insertable = false, updatable = false)
    private BancoConveniado banco;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_conta", nullable = false)
    private TipoConta tipoConta;

    @Column(name = "saldo", precision = 15, scale = 2)
    private BigDecimal saldo = BigDecimal.ZERO;

    @Column(name = "data_abertura", nullable = false)
    private LocalDate dataAbertura;

    @Column(name = "status")
    private Boolean status = true;

    public enum TipoConta {
        CORRENTE, POUPANCA, DIGITAL
    }
}