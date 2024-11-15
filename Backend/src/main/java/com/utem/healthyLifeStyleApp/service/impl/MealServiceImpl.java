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


		Meal meal = Meal.builder()
				.user(mapper.fromDTO(request.getUser()))
				.mealType(request.getMealType())
				.calories(request.getCalories())
				.amountInGrams(request.getAmountInGrams())
				.food(request.getFood())
				.carbsInGrams(request.getCarbsInGrams())
				.proteinInGrams(request.getProteinInGrams())
				.fatInGrams(request.getFatInGrams())
				.date(LocalDate.now())
				.build();

		return mealRepo.save(meal);
	}

}
