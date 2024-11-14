package com.utem.healthyLifeStyleApp.dto;

import com.utem.healthyLifeStyleApp.model.Food;
import com.utem.healthyLifeStyleApp.model.Meal.MealType;
import com.utem.healthyLifeStyleApp.model.User;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class AddFoodToMealReq {
	
	private MealType mealType;
	private UserDTO user;
	private Double amountInGrams;
	private Food food;
}
