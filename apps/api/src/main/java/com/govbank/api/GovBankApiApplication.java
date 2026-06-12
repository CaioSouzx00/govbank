package com.govbank.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * GovBank Core API - Aplicação Principal
 * 
 * Sistema de processamento de benefícios governamentais
 * Arquitetura híbrida: Java (REST) + COBOL (Processamento) + PostgreSQL
 * 
 * @author GovBank Core Team
 * @version 1.0.0
 */
@SpringBootApplication
@EnableJpaAuditing
public class GovBankApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(GovBankApiApplication.class, args);
        
        System.out.println("========================================");
        System.out.println("  GovBank Core API - INICIADO");
        System.out.println("  Porta: 8080");
        System.out.println("  Swagger: http://localhost:8080/swagger-ui.html");
        System.out.println("  Actuator: http://localhost:8080/actuator/health");
        System.out.println("========================================");
    }
}
