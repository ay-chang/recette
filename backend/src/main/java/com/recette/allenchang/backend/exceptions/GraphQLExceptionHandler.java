package com.recette.allenchang.backend.exceptions;

import graphql.GraphQLError;
import graphql.GraphqlErrorBuilder;
import graphql.schema.DataFetchingEnvironment;
import org.springframework.graphql.execution.DataFetcherExceptionResolver;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class GraphQLExceptionHandler implements DataFetcherExceptionResolver {

    @Override
    public Mono<List<GraphQLError>> resolveException(Throwable ex, DataFetchingEnvironment env) {
        if (ex instanceof InvalidCredentialsException ||
                ex instanceof EmailAlreadyInUseException ||
                ex instanceof InvalidInputException) {
            return Mono.just(List.of(
                    GraphqlErrorBuilder.newError(env)
                            .message(ex.getMessage())
                            .build()));
        }

        // Fallback: generic error message
        return Mono.just(List.of(
                GraphqlErrorBuilder.newError(env)
                        .message("Unexpected server error")
                        .build()));
    }
}
