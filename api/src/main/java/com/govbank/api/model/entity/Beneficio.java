package com.govbank.api.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "beneficio")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Beneficio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cpf_cidadao", nullable = false)
    @NotNull(message = "Cidadão é obrigatório")
    private Cidadao cidadao;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_programa", nullable = false)
    @NotNull(message = "Programa social é obrigatório")
    private ProgramaSocial programaSocial;

    @Column(name = "valor_calculado", precision = 10, scale = 2, nullable = false)
    @DecimalMin(value = "0.01", message = "Valor calculado deve ser maior que zero")
    private BigDecimal valorCalculado;

    @Column(name = "data_concessao", nullable = false)
    @NotNull(message = "Data de concessão é obrigatória")
    private LocalDate dataConcessao;

    @Column(name = "data_validade")
    private LocalDate dataValidade;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 10, nullable = false)
    private StatusBeneficio status = StatusBeneficio.CONCEDIDO;

    @Column(name = "motivo_concessao", columnDefinition = "TEXT")
    private String motivoConcessao;

    public enum StatusBeneficio {
        CONCEDIDO,
        ATIVO,
        SUSPENSO,
        CANCELADO,
        FINALIZADO
    }
}
