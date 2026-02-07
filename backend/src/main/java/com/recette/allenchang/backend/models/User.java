package com.recette.allenchang.backend.models;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

import com.recette.allenchang.backend.models.Friendship;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.models.Tag;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue
    private UUID id;
    @Column(unique = true)
    private String username;

    @Column(unique = true)
    private String email;

    private String password;
    private String firstName;
    private String lastName;

    @Column(unique = true)
    private String appleId;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Recipe> recipes;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Tag> tags;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Grocery> groceries;

    @OneToMany(mappedBy = "user")
    private List<Friendship> sentFriendRequests;

    @OneToMany(mappedBy = "friend")
    private List<Friendship> receivedFriendRequests;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    /** Getters and setters */
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<Recipe> getRecipes() {
        return recipes;
    }

    public void setRecipes(List<Recipe> recipes) {
        this.recipes = recipes;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getAppleId() {
        return appleId;
    }

    public void setAppleId(String appleId) {
        this.appleId = appleId;
    }

}
