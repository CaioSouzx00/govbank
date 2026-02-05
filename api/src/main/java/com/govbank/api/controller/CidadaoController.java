package com.govbank.api.controller;

import com.govbank.api.model.dto.CidadaoDTO;
import com.govbank.api.service.CidadaoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
}
