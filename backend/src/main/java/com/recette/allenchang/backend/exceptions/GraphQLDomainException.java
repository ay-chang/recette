package com.recette.allenchang.backend.exceptions;

public abstract class GraphQLDomainException extends RuntimeException {
    public GraphQLDomainException(String message) {
        super(message);
    }
}
