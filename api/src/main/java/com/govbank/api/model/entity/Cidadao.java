package com.govbank.api.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "cidadao")
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cidadao {

    @Id
    @Column(name = "cpf", length = 11, nullable = false)
    @Pattern(regexp = "\\d{11}", message = "CPF deve conter 11 dígitos")
    private String cpf;

    @Column(name = "nome", length = 200, nullable = false)
    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 200, message = "Nome deve ter no máximo 200 caracteres")
    private String nome;

    @Column(name = "data_nascimento", nullable = false)
    @NotNull(message = "Data de nascimento é obrigatória")
    @Past(message = "Data de nascimento deve ser no passado")
    private LocalDate dataNascimento;

    @Column(name = "renda_familiar", precision = 10, scale = 2)
    @DecimalMin(value = "0.0", inclusive = true, message = "Renda familiar não pode ser negativa")
    private BigDecimal rendaFamiliar;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 10, nullable = false)
    private StatusCidadao status = StatusCidadao.ATIVO;

    @CreatedDate
    @Column(name = "data_cadastro", nullable = false, updatable = false)
    private LocalDateTime dataCadastro;

    @LastModifiedDate
    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;

    public enum StatusCidadao {
        ATIVO,
        BLOQUEADO,
        SUSPEITO,
        INATIVO
    }
}
