package com.govbank.api.controller;

import com.govbank.api.model.entity.ProgramaSocial;
import com.govbank.api.repository.ProgramaSocialRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/programas")
@RequiredArgsConstructor
@Tag(name = "Programas Sociais", description = "Endpoints para consulta de programas sociais")
public class ProgramaSocialController {

    private final ProgramaSocialRepository programaSocialRepository;

    @GetMapping
    @Operation(summary = "Listar programas ativos", description = "Retorna todos os programas sociais ativos")
    public ResponseEntity<List<ProgramaSocial>> listarAtivos() {
        List<ProgramaSocial> programas = programaSocialRepository.findByAtivoTrue();
        return ResponseEntity.ok(programas);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar programa por ID", description = "Retorna um programa social pelo ID")
    public ResponseEntity<ProgramaSocial> buscarPorId(@PathVariable Integer id) {
        return programaSocialRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/todos")
    @Operation(summary = "Listar todos os programas", description = "Retorna todos os programas (ativos e inativos)")
    public ResponseEntity<List<ProgramaSocial>> listarTodos() {
        List<ProgramaSocial> programas = programaSocialRepository.findAll();
        return ResponseEntity.ok(programas);
    }
}
