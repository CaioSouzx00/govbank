package com.govbank.api.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.govbank.api.model.entity.Beneficio;
import com.govbank.api.service.BeneficioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/beneficios")
@RequiredArgsConstructor
@Tag(name = "Benefícios", description = "Endpoints para consulta de benefícios")
public class BeneficioController {

    private final BeneficioService beneficioService;

    @GetMapping
    @Operation(summary = "Listar benefícios", description = "Retorna benefícios filtrados por CPF ou status")
    public ResponseEntity<List<Beneficio>> listar(
            @RequestParam(required = false) String cpf,
            @RequestParam(required = false) Beneficio.StatusBeneficio status) {

        if (cpf != null) {
            return ResponseEntity.ok(beneficioService.listarPorCpf(cpf));
        }
        if (status != null) {
            return ResponseEntity.ok(beneficioService.listarPorStatus(status));
        }
        return ResponseEntity.ok(beneficioService.listarTodos());
    }
}