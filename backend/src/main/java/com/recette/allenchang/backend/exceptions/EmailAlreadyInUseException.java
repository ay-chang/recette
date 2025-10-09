package com.recette.allenchang.backend.exceptions;

public class EmailAlreadyInUseException extends GraphQLDomainException {
    public EmailAlreadyInUseException(String message) {
        super(message);
    }
}
