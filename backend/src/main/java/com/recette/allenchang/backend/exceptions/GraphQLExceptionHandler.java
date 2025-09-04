package com.recette.allenchang.backend.exceptions;

import graphql.GraphQLError;
import graphql.GraphqlErrorBuilder;
import graphql.schema.DataFetchingEnvironment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.graphql.execution.DataFetcherExceptionResolver;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class GraphQLExceptionHandler implements DataFetcherExceptionResolver {

    private static final Logger logger = LoggerFactory.getLogger(GraphQLExceptionHandler.class);

    @Override
    public Mono<List<GraphQLError>> resolveException(Throwable ex, DataFetchingEnvironment env) {
        /** Always log the exception */
        logger.error("Exception in GraphQL resolver for field '{}': {}",
                env.getField().getName(), ex.getMessage());

        if (ex instanceof GraphQLDomainException) {
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
