package com.govbank.api.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "programa_social")
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProgramaSocial {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "nome_programa", length = 100, nullable = false, unique = true)
    @NotBlank(message = "Nome do programa é obrigatório")
    private String nomePrograma;

    @Column(name = "descricao", columnDefinition = "TEXT")
    private String descricao;

    @Column(name = "valor_base", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Valor base é obrigatório")
    @DecimalMin(value = "0.01", message = "Valor base deve ser maior que zero")
    private BigDecimal valorBase;

    @Column(name = "renda_max_elegib", precision = 10, scale = 2)
    private BigDecimal rendaMaxElegibilidade;

    @Column(name = "orgao_resp", length = 100, nullable = false)
    @NotBlank(message = "Órgão responsável é obrigatório")
    private String orgaoResponsavel;

    @Column(name = "ativo", nullable = false)
    private Boolean ativo = true;

    @CreatedDate
    @Column(name = "data_criacao", nullable = false, updatable = false)
    private LocalDateTime dataCriacao;
}
