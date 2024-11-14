package com.utem.healthyLifeStyleApp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.utem.healthyLifeStyleApp.dto.UserDTO;
import com.utem.healthyLifeStyleApp.service.impl.UserServiceImpl;

@RestController
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	private UserServiceImpl userService;
	
	 @GetMapping("/{id}")
	 public ResponseEntity<UserDTO> getUserById(@PathVariable("id") Integer id) {
		 return ResponseEntity.status(HttpStatus.OK).body(userService.getUserById(id));
	 }

}
