package com.recette.allenchang.backend.exceptions;

public class InvalidInputException extends GraphQLDomainException {
    public InvalidInputException(String message) {
        super(message);
    }
}
