package com.govbank.api.model.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "banco_conveniado")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class BancoConveniado {

    @Id
    @Column(name = "cod_banco", length = 3)
    private String codBanco;

    @Column(name = "nome_banco", length = 100, nullable = false)
    private String nomeBanco;

    @Column(name = "cnpj", length = 14, nullable = false, unique = true)
    private String cnpj;

    @Column(name = "status_convenio")
    private Boolean statusConvenio = true;

    @Column(name = "data_convenio", nullable = false)
    private LocalDate dataConvenio;

    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;
}