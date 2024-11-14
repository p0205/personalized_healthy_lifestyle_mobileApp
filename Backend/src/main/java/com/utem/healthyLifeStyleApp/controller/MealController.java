package com.utem.healthyLifeStyleApp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.utem.healthyLifeStyleApp.dto.AddFoodToMealReq;
import com.utem.healthyLifeStyleApp.model.Meal;
import com.utem.healthyLifeStyleApp.service.impl.MealServiceImpl;

@RestController
@RequestMapping("/meals")
public class MealController {
	
	@Autowired
	private MealServiceImpl mealService;
	
	@PostMapping
	public ResponseEntity<Meal> addFoodtoMeal(@RequestBody AddFoodToMealReq request){

		return ResponseEntity.status(HttpStatus.CREATED).body(mealService.addFoodToMeal(request));
	}

}
