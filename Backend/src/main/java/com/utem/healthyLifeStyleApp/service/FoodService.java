package com.utem.healthyLifeStyleApp.service;

import java.util.List;

import com.utem.healthyLifeStyleApp.dto.FoodSearchDTO;
import com.utem.healthyLifeStyleApp.model.Food;

public interface FoodService {

	
	public List<FoodSearchDTO> getMatchingFoodList(String name);
	public Food getById(Integer id);
}
