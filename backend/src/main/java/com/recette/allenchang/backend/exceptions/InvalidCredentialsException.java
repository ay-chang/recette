package com.recette.allenchang.backend.exceptions;

public class InvalidCredentialsException extends GraphQLDomainException {
    public InvalidCredentialsException(String message) {
        super(message);
    }
}
