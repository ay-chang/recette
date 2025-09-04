package com.recette.allenchang.backend.exceptions;

public class DuplicateTagException extends GraphQLDomainException {
    public DuplicateTagException(String message) {
        super(message);
    }
}
