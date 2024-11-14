package com.utem.healthyLifeStyleApp.model;

import java.io.Serializable;
import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Meal implements Serializable{
	
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	
	@ManyToOne
	@JoinColumn(name = "user_id",nullable = false)
	private User user;
	
	@Enumerated(EnumType.STRING)
	private MealType mealType; 
	
	private LocalDate date;
	
	public enum MealType {
		BREAKFAST,
		LUNCH,
		DINNER,
		SNACK
	}
	
	@ManyToOne
	@JoinColumn(name = "food_id",nullable = false)
	private Food food;
	
	private Double amountInGrams;
	
	private Double calories;
	
	private Double carbsInGrams;
	
	private Double proteinInGrams;
	
	private Double fatInGrams;


}

