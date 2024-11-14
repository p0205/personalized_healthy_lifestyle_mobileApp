package com.utem.healthyLifeStyleApp.service;

import com.utem.healthyLifeStyleApp.dto.AddFoodToMealReq;
import com.utem.healthyLifeStyleApp.model.Meal;

public interface MealService {

	 public Meal addFoodToMeal(AddFoodToMealReq request);
}
