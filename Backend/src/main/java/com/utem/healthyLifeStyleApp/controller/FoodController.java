package com.utem.healthyLifeStyleApp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.utem.healthyLifeStyleApp.dto.FoodSearchDTO;
import com.utem.healthyLifeStyleApp.model.Food;
import com.utem.healthyLifeStyleApp.service.impl.FoodServiceImpl;

@RestController
@RequestMapping("/food")
public class FoodController {

	@Autowired
	private FoodServiceImpl foodService;
	
	
	@GetMapping("/search")
	public ResponseEntity<List<FoodSearchDTO>> getMatchingFoodList(@RequestParam String name){
	
		System.out.println("Request arrived");
		return ResponseEntity.status(HttpStatus.OK).body(foodService.getMatchingFoodList(name));
		
	}
	
	@GetMapping("/{id}")
	public ResponseEntity<Food> getFoodList(@PathVariable("id") Integer id){
		return ResponseEntity.status(HttpStatus.OK).body(foodService.getById(id));
	}
	

}
