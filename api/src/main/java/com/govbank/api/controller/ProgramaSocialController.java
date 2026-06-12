package com.govbank.api.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.govbank.api.model.entity.ProgramaSocial;
import com.govbank.api.service.ProgramaSocialService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/programas")
@RequiredArgsConstructor
@Tag(name = "Programas Sociais", description = "Endpoints para consulta de programas sociais")
public class ProgramaSocialController {

    private final ProgramaSocialService programaSocialService;

    @GetMapping
    @Operation(summary = "Listar programas ativos", description = "Retorna todos os programas sociais ativos")
    public ResponseEntity<List<ProgramaSocial>> listarAtivos() {
        return ResponseEntity.ok(programaSocialService.listarAtivos());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar programa por ID", description = "Retorna um programa social pelo ID")
    public ResponseEntity<ProgramaSocial> buscarPorId(@PathVariable Integer id) {
        return ResponseEntity.ok(programaSocialService.buscarPorId(id));
    }

    @GetMapping("/todos")
    @Operation(summary = "Listar todos os programas", description = "Retorna todos os programas (ativos e inativos)")
    public ResponseEntity<List<ProgramaSocial>> listarTodos() {
        return ResponseEntity.ok(programaSocialService.listarTodos());
    }
}