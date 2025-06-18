package com.recette.allenchang.backend.models;

import jakarta.persistence.*;

@Entity
@Table(name = "tags")
public class Tag {

    /** Set id as the primary key, system auto increments by one */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;

    /** Many to one relationship between tags and a user. Many tags for one user */
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /** Constructor, getters, and setters */
    public Tag() {
    }

    public Tag(String name, User user) {
        this.name = name;
        this.user = user;
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

}
