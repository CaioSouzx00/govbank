package com.govbank.api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Value("${govbank.api.cors.allowed-origins}")
    private String allowedOrigins;

    @Value("${govbank.api.cors.allowed-methods}")
    private String allowedMethods;

    @Value("${govbank.api.cors.allowed-headers}")
    private String allowedHeaders;

    @Value("${govbank.api.cors.allow-credentials}")
    private boolean allowCredentials;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(allowedOrigins.split(","))
                .allowedMethods(allowedMethods.split(","))
                .allowedHeaders(allowedHeaders.split(","))
                .allowCredentials(allowCredentials);
    }
}