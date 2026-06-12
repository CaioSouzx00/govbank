package com.govbank.api.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govbank.api.exception.ResourceNotFoundException;
import com.govbank.api.model.entity.BancoConveniado;
import com.govbank.api.model.entity.Cidadao;
import com.govbank.api.model.entity.ContaBancaria;
import com.govbank.api.model.entity.ContaBancariaId;
import com.govbank.api.repository.BancoConviadoRepository;
import com.govbank.api.repository.CidadaoRepository;
import com.govbank.api.repository.ContaBancariaRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContaBancariaService {

    private final ContaBancariaRepository contaRepository;
    private final CidadaoRepository cidadaoRepository;
    private final BancoConviadoRepository bancoRepository;

    @Transactional(readOnly = true)
    public List<ContaBancaria> listarPorCpf(String cpf) {
        log.info("Listando contas do cidadão CPF: {}", cpf);
        return contaRepository.findByTitularCpf(cpf);
    }

    @Transactional
    public ContaBancaria cadastrar(String cpf, Map<String, String> dados) {
        log.info("Cadastrando conta para cidadão CPF: {}", cpf);

        Cidadao cidadao = cidadaoRepository.findById(cpf)
                .orElseThrow(() -> new ResourceNotFoundException("Cidadão não encontrado: " + cpf));

        BancoConveniado banco = bancoRepository.findById(dados.get("codBanco"))
                .orElseThrow(() -> new ResourceNotFoundException("Banco não encontrado: " + dados.get("codBanco")));

        if (!banco.getStatusConvenio()) {
            throw new IllegalArgumentException("Banco " + banco.getNomeBanco() + " não está ativo no convênio");
        }

        ContaBancaria conta = ContaBancaria.builder()
                .agencia(dados.get("agencia"))
                .conta(dados.get("conta"))
                .codBanco(dados.get("codBanco"))
                .titular(cidadao)
                .banco(banco)
                .tipoConta(ContaBancaria.TipoConta.valueOf(dados.get("tipoConta")))
                .dataAbertura(LocalDate.now())
                .status(true)
                .build();

        return contaRepository.save(conta);
    }

    @Transactional
    public void inativar(String agencia, String conta, String codBanco) {
        log.info("Inativando conta {}/{}/{}", agencia, conta, codBanco);
        ContaBancariaId id = new ContaBancariaId(agencia, conta, codBanco);
        ContaBancaria contaBancaria = contaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Conta não encontrada"));
        contaBancaria.setStatus(false);
        contaRepository.save(contaBancaria);
    }
}