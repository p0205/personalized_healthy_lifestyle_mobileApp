package com.utem.healthyLifeStyleApp.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.utem.healthyLifeStyleApp.model.Meal;

public interface MealRepo extends JpaRepository<Meal, Integer>{
	
}
