package com.utem.healthyLifeStyleApp.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.utem.healthyLifeStyleApp.model.User;

@Repository
public interface UserRepo extends JpaRepository<User,Integer>{

}
