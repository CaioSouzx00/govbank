package com.govbank.api.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.govbank.api.model.dto.CidadaoDTO;
import com.govbank.api.service.CidadaoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/cidadaos")
@RequiredArgsConstructor
@Tag(name = "Cidadãos", description = "Endpoints para gerenciamento de cidadãos")
public class CidadaoController {

    private final CidadaoService cidadaoService;

    @PostMapping
    @Operation(summary = "Cadastrar novo cidadão", description = "Cadastra um novo cidadão no sistema")
    public ResponseEntity<CidadaoDTO> cadastrar(@Valid @RequestBody CidadaoDTO dto) {
        CidadaoDTO cadastrado = cidadaoService.cadastrar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(cadastrado);
    }

    @GetMapping("/{cpf}")
    @Operation(summary = "Buscar cidadão por CPF", description = "Retorna os dados de um cidadão pelo CPF")
    public ResponseEntity<CidadaoDTO> buscarPorCpf(@PathVariable String cpf) {
        CidadaoDTO cidadao = cidadaoService.buscarPorCpf(cpf);
        return ResponseEntity.ok(cidadao);
    }

    @GetMapping
    @Operation(summary = "Listar todos os cidadãos", description = "Retorna lista de todos os cidadãos cadastrados")
    public ResponseEntity<List<CidadaoDTO>> listarTodos() {
        List<CidadaoDTO> cidadaos = cidadaoService.listarTodos();
        return ResponseEntity.ok(cidadaos);
    }

    @PutMapping("/{cpf}")
    @Operation(summary = "Atualizar cidadão", description = "Atualiza os dados de um cidadão existente")
    public ResponseEntity<CidadaoDTO> atualizar(
            @PathVariable String cpf,
            @Valid @RequestBody CidadaoDTO dto) {
        CidadaoDTO atualizado = cidadaoService.atualizar(cpf, dto);
        return ResponseEntity.ok(atualizado);
    }

    @PatchMapping("/{cpf}/status")
    @Operation(summary = "Alterar status do cidadão", description = "Altera o status do cidadão (ATIVO, BLOQUEADO, SUSPEITO, INATIVO)")
    public ResponseEntity<CidadaoDTO> alterarStatus(
            @PathVariable String cpf,
            @RequestParam String status) {
        CidadaoDTO atualizado = cidadaoService.alterarStatus(cpf, status);
        return ResponseEntity.ok(atualizado);
    }

    @DeleteMapping("/{cpf}")
    @Operation(summary = "Inativar cidadão", description = "Inativa um cidadão (soft delete — altera status para INATIVO)")
    public ResponseEntity<Void> inativar(@PathVariable String cpf) {
        cidadaoService.inativar(cpf);
        return ResponseEntity.noContent().build();
    }
}