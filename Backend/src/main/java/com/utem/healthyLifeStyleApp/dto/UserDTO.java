package com.utem.healthyLifeStyleApp.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class UserDTO {

	private int id;
	private String name;
	private String email;
	private char gender;
	private Integer age;
	private Double weight;
	private Double height;
	private Integer goalCalories; //daily calories set by user
	
	
}
