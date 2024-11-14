package com.utem.healthyLifeStyleApp.service.impl;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.utem.healthyLifeStyleApp.dto.AddFoodToMealReq;
import com.utem.healthyLifeStyleApp.mapper.UserMapper;
import com.utem.healthyLifeStyleApp.model.Food;
import com.utem.healthyLifeStyleApp.model.Meal;
import com.utem.healthyLifeStyleApp.repo.MealRepo;
import com.utem.healthyLifeStyleApp.service.MealService;


@Service
public class MealServiceImpl implements MealService{

	@Autowired
	private MealRepo mealRepo;
	
	@Autowired
	private UserMapper mapper;
	
	@Override
	public Meal addFoodToMeal(AddFoodToMealReq request) {
		
		
		
		double amountInGrams = request.getAmountInGrams();
		
		Food food = request.getFood();
	
	
	
		Double carbsInGrams = food.getCarbsPer100g() != null ? (food.getCarbsPer100g()/100 * amountInGrams) : null;
		

		
		Double calories = food.getEnergyPer100g() != null ? (Double)(food.getEnergyPer100g()/100 * amountInGrams)  : null ;
		
	

		Double proteinInGrams = food.getProteinPer100g() != null ? (Double)(food.getProteinPer100g()/100 * amountInGrams)  : null ;
		

		Double fatInGrams = food.getFatPer100g() != null ?(Double)(food.getFatPer100g()/100 * amountInGrams)  : null ;

		try {
			
		}catch(Exception e) {
			
		}
		
		Meal meal = Meal.builder()
				.user(mapper.fromDTO(request.getUser()))
				.mealType(request.getMealType())
				.calories(calories)
				.amountInGrams(amountInGrams)
				.food(food)
				.carbsInGrams(carbsInGrams)
				.proteinInGrams(proteinInGrams)
				.fatInGrams(fatInGrams)
				.date(LocalDate.now())
				.build();
		

		return mealRepo.save(meal);
		
		
	}

}
