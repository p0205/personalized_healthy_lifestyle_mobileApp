package com.utem.healthyLifeStyleApp.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.utem.healthyLifeStyleApp.dto.FoodSearchDTO;
import com.utem.healthyLifeStyleApp.model.Food;

@Mapper(componentModel = "spring")
public interface FoodMapper {
	
	public List<FoodSearchDTO> toFoodSearchDTOList(List<Food> food);

}
