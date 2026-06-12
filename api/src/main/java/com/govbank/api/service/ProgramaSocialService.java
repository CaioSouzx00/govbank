package com.govbank.api.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govbank.api.exception.ResourceNotFoundException;
import com.govbank.api.model.entity.ProgramaSocial;
import com.govbank.api.repository.ProgramaSocialRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProgramaSocialService {

    private final ProgramaSocialRepository programaSocialRepository;

    @Transactional(readOnly = true)
    public List<ProgramaSocial> listarAtivos() {
        log.info("Listando programas sociais ativos");
        return programaSocialRepository.findByAtivoTrue();
    }

    @Transactional(readOnly = true)
    public List<ProgramaSocial> listarTodos() {
        log.info("Listando todos os programas sociais");
        return programaSocialRepository.findAll();
    }

    @Transactional(readOnly = true)
    public ProgramaSocial buscarPorId(Integer id) {
        log.info("Buscando programa social com ID: {}", id);
        return programaSocialRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Programa social não encontrado com ID: " + id));
    }
}