package com.govbank.api.model.entity;

import java.time.LocalDateTime;
import java.util.Map;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "fila_processamento")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class FilaProcessamento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_operacao", nullable = false)
    private TipoOperacao tipoOperacao;

    @Column(name = "id_referencia")
    private Long idReferencia;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "payload_json", columnDefinition = "jsonb", nullable = false)
    private Map<String, Object> payloadJson;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 15)
    private StatusFila status = StatusFila.PENDENTE;

    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao = LocalDateTime.now();

    @Column(name = "data_processamento")
    private LocalDateTime dataProcessamento;

    @Column(name = "mensagem_erro", columnDefinition = "TEXT")
    private String mensagemErro;

    @Column(name = "tentativas")
    private Integer tentativas = 0;

    public enum TipoOperacao {
        VALIDAR_CPF, CALCULAR_BENEFICIO, GERAR_PAGAMENTO, CONCILIAR
    }

    public enum StatusFila {
        PENDENTE, PROCESSANDO, CONCLUIDO, ERRO, RETRY
    }
}