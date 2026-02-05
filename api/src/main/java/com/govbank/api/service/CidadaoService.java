package com.govbank.api.service;

import com.govbank.api.exception.ResourceNotFoundException;
import com.govbank.api.model.dto.CidadaoDTO;
import com.govbank.api.model.entity.Cidadao;
import com.govbank.api.repository.CidadaoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CidadaoService {

    private final CidadaoRepository cidadaoRepository;

    @Transactional
    public CidadaoDTO cadastrar(CidadaoDTO dto) {
        log.info("Cadastrando cidadão com CPF: {}", dto.getCpf());
        
        if (cidadaoRepository.existsByCpf(dto.getCpf())) {
            throw new IllegalArgumentException("CPF já cadastrado");
        }
        
        Cidadao cidadao = Cidadao.builder()
                .cpf(dto.getCpf())
                .nome(dto.getNome())
                .dataNascimento(dto.getDataNascimento())
                .rendaFamiliar(dto.getRendaFamiliar())
                .status(Cidadao.StatusCidadao.ATIVO)
                .build();
        
        cidadao = cidadaoRepository.save(cidadao);
        log.info("Cidadão cadastrado com sucesso: {}", cidadao.getCpf());
        
        return toDTO(cidadao);
    }

    @Transactional(readOnly = true)
    public CidadaoDTO buscarPorCpf(String cpf) {
        log.info("Buscando cidadão com CPF: {}", cpf);
        
        Cidadao cidadao = cidadaoRepository.findById(cpf)
                .orElseThrow(() -> new ResourceNotFoundException("Cidadão não encontrado com CPF: " + cpf));
        
        return toDTO(cidadao);
    }

    @Transactional(readOnly = true)
    public List<CidadaoDTO> listarTodos() {
        log.info("Listando todos os cidadãos");
        return cidadaoRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    private CidadaoDTO toDTO(Cidadao cidadao) {
        return CidadaoDTO.builder()
                .cpf(cidadao.getCpf())
                .nome(cidadao.getNome())
                .dataNascimento(cidadao.getDataNascimento())
                .rendaFamiliar(cidadao.getRendaFamiliar())
                .status(cidadao.getStatus().name())
                .build();
    }
}
