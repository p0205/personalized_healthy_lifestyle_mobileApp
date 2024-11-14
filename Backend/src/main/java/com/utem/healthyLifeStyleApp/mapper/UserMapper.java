package com.utem.healthyLifeStyleApp.mapper;

import org.mapstruct.Mapper;

import com.utem.healthyLifeStyleApp.dto.UserDTO;
import com.utem.healthyLifeStyleApp.model.User;


@Mapper(componentModel = "spring")
public interface UserMapper {

	 User fromDTO(UserDTO dto);
	 UserDTO toDTO(User user);
}
