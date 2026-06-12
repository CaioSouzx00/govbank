package com.govbank.api.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.govbank.api.model.entity.BancoConveniado;
import com.govbank.api.service.BancoConviadoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/bancos")
@RequiredArgsConstructor
@Tag(name = "Bancos Conveniados", description = "Consulta de bancos parceiros")
public class BancoConviadoController {

    private final BancoConviadoService service;

    @GetMapping
    @Operation(summary = "Listar bancos ativos")
    public ResponseEntity<List<BancoConveniado>> listarAtivos() {
        return ResponseEntity.ok(service.listarAtivos());
    }

    @GetMapping("/todos")
    @Operation(summary = "Listar todos os bancos")
    public ResponseEntity<List<BancoConveniado>> listarTodos() {
        return ResponseEntity.ok(service.listarTodos());
    }

    @GetMapping("/{codBanco}")
    @Operation(summary = "Buscar banco por código")
    public ResponseEntity<BancoConveniado> buscarPorCodigo(@PathVariable String codBanco) {
        return ResponseEntity.ok(service.buscarPorCodigo(codBanco));
    }
}