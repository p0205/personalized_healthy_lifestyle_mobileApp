package com.utem.healthyLifeStyleApp.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.utem.healthyLifeStyleApp.dto.FoodSearchDTO;
import com.utem.healthyLifeStyleApp.mapper.FoodMapper;
import com.utem.healthyLifeStyleApp.model.Food;
import com.utem.healthyLifeStyleApp.repo.FoodRepo;
import com.utem.healthyLifeStyleApp.service.FoodService;

@Service
public class FoodServiceImpl implements FoodService{
	
	@Autowired
	private FoodRepo foodRepo;
	
	@Autowired
	private FoodMapper mapper;

	@Override
	public List<FoodSearchDTO> getMatchingFoodList(String name) {
		return mapper.toFoodSearchDTOList(foodRepo.findByNameLike("%"+name+"%"));
	}

	@Override
	public Food getById(Integer id) {
		
		Optional<Food> food = foodRepo.findById(id);
		if(food.isEmpty())
			return null;
		return food.get();
	}

}
