package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.dto.requests.UpdateAccountDetailsRequest;
import com.recette.allenchang.backend.dto.responses.UserResponse;
import com.recette.allenchang.backend.mappers.UserMapper;
import com.recette.allenchang.backend.security.JwtUtil;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserQueryService userQueryService;
    private final UserMutationService userMutationService;
    private final com.recette.allenchang.backend.repositories.UserRepository userRepository;

    public UserController(UserQueryService userQueryService, UserMutationService userMutationService,
            com.recette.allenchang.backend.repositories.UserRepository userRepository) {
        this.userQueryService = userQueryService;
        this.userMutationService = userMutationService;
        this.userRepository = userRepository;
    }

    @GetMapping("/search")
    public List<UserResponse> searchUsers(@RequestParam String query) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        List<User> users = userRepository.findByUsernameContainingIgnoreCaseAndEmailNot(
                query, userEmail, PageRequest.of(0, 20));
        return users.stream()
                .map(UserMapper::toResponse)
                .toList();
    }

    @GetMapping("/me")
    public UserResponse getCurrentUser() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        User user = userQueryService.getUserDetails(userEmail);
        return UserMapper.toResponse(user);
    }

    @GetMapping("/{email}/username")
    public String getUsername(@PathVariable String email) {
        return userQueryService.getUsername(email);
    }

    @PutMapping("/me")
    public UserResponse updateCurrentUser(@RequestBody UpdateAccountDetailsRequest request) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        User user = userMutationService.updateAccountDetails(userEmail, request);
        return UserMapper.toResponse(user);
    }

    @DeleteMapping("/me")
    public ResponseEntity<Void> deleteCurrentUser() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        userMutationService.deleteUserByEmail(userEmail);
        return ResponseEntity.noContent().build();
    }
}
