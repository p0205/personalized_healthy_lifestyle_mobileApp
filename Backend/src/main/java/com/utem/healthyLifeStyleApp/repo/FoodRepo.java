package com.utem.healthyLifeStyleApp.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.utem.healthyLifeStyleApp.model.Food;

@Repository
public interface FoodRepo extends JpaRepository<Food,Integer>{

	public Food findByName(String name);
	
	
	public List<Food> findByNameLike(String name);
}
