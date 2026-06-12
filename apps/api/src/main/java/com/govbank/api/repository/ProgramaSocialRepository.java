package com.govbank.api.repository;

import com.govbank.api.model.entity.ProgramaSocial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProgramaSocialRepository extends JpaRepository<ProgramaSocial, Integer> {
    
    List<ProgramaSocial> findByAtivoTrue();
}
