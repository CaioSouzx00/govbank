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
                .dataCadastro(cidadao.getDataCadastro())
                .dataAtualizacao(cidadao.getDataAtualizacao())
                .build();
    }

    @Transactional
    public CidadaoDTO alterarStatus(String cpf, String novoStatus) {
        log.info("Alterando status do cidadão CPF: {} para {}", cpf, novoStatus);

        Cidadao cidadao = cidadaoRepository.findById(cpf)
                .orElseThrow(() -> new ResourceNotFoundException("Cidadão não encontrado com CPF: " + cpf));

        try {
            cidadao.setStatus(Cidadao.StatusCidadao.valueOf(novoStatus.toUpperCase()));
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Status inválido: " + novoStatus +
                    ". Valores aceitos: ATIVO, BLOQUEADO, SUSPEITO, INATIVO");
        }

        cidadao = cidadaoRepository.save(cidadao);
        log.info("Status do cidadão {} alterado para {}", cpf, novoStatus);
        return toDTO(cidadao);
    }

    @Transactional
    public void inativar(String cpf) {
        log.info("Inativando cidadão CPF: {}", cpf);

        Cidadao cidadao = cidadaoRepository.findById(cpf)
                .orElseThrow(() -> new ResourceNotFoundException("Cidadão não encontrado com CPF: " + cpf));

        cidadao.setStatus(Cidadao.StatusCidadao.INATIVO);
        cidadaoRepository.save(cidadao);
        log.info("Cidadão {} inativado com sucesso", cpf);
    }

    @Transactional
    public CidadaoDTO atualizar(String cpf, CidadaoDTO dto) {
        log.info("Atualizando cidadão com CPF: {}", cpf);

        Cidadao cidadao = cidadaoRepository.findById(cpf)
                .orElseThrow(() -> new ResourceNotFoundException("Cidadão não encontrado com CPF: " + cpf));

        cidadao.setNome(dto.getNome());
        cidadao.setDataNascimento(dto.getDataNascimento());
        cidadao.setRendaFamiliar(dto.getRendaFamiliar());

        if (dto.getStatus() != null) {
            try {
                cidadao.setStatus(Cidadao.StatusCidadao.valueOf(dto.getStatus()));
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Status inválido: " + dto.getStatus());
            }
        }
        cidadao = cidadaoRepository.save(cidadao);
        log.info("Cidadão atualizado com sucesso: {}", cidadao.getCpf());

        return toDTO(cidadao);
    }

}
