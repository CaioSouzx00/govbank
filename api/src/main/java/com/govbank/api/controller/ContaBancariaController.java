package com.govbank.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.govbank.api.model.entity.ContaBancaria;
import com.govbank.api.service.ContaBancariaService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/contas")
@RequiredArgsConstructor
@Tag(name = "Contas Bancárias", description = "Gerenciamento de contas bancárias dos cidadãos")
public class ContaBancariaController {

    private final ContaBancariaService service;

    @GetMapping
    @Operation(summary = "Listar contas por CPF do titular")
    public ResponseEntity<List<ContaBancaria>> listarPorCpf(@RequestParam String cpf) {
        return ResponseEntity.ok(service.listarPorCpf(cpf));
    }

    @PostMapping("/{cpf}")
    @Operation(summary = "Cadastrar nova conta para um cidadão")
    public ResponseEntity<ContaBancaria> cadastrar(
            @PathVariable String cpf,
            @RequestBody Map<String, String> dados) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.cadastrar(cpf, dados));
    }

    @DeleteMapping("/{agencia}/{conta}/{codBanco}")
    @Operation(summary = "Inativar uma conta bancária")
    public ResponseEntity<Void> inativar(
            @PathVariable String agencia,
            @PathVariable String conta,
            @PathVariable String codBanco) {
        service.inativar(agencia, conta, codBanco);
        return ResponseEntity.noContent().build();
    }
}