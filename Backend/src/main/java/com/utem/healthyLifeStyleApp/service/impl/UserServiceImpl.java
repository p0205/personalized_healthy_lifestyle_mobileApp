package com.utem.healthyLifeStyleApp.service.impl;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.utem.healthyLifeStyleApp.dto.UserDTO;
import com.utem.healthyLifeStyleApp.mapper.UserMapper;
import com.utem.healthyLifeStyleApp.model.User;
import com.utem.healthyLifeStyleApp.repo.UserRepo;
import com.utem.healthyLifeStyleApp.service.UserService;

@Service
public class UserServiceImpl implements UserService{
	
	@Autowired
	private UserRepo userRepo;
	
	@Autowired
	private UserMapper mapper;

	@Override
	public UserDTO getUserById(Integer id) {
		
		Optional<User> user = userRepo.findById(id);
		if(user.isEmpty())
			return null;
		return mapper.toDTO(user.get());
		
	}

}
