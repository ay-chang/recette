import Apollo
import Foundation

class Network {
    static var shared = Network()

    let apollo: ApolloClient

    private init() {
        let url = URL(string: "\(Config.backendBaseURL)/api/graphql")!
        let store = ApolloStore()

        let transport = RequestChainNetworkTransport(
            interceptorProvider: DefaultInterceptorProvider(store: store),
            endpointURL: url,
            additionalHeaders: {
                if let token = AuthManager.shared.jwtToken {
                    return ["Authorization": "Bearer \(token)"]
                } else {
                    return [:]
                }
            }()
        )

        self.apollo = ApolloClient(networkTransport: transport, store: store)
    }

    /** Call this after login to re-create ApolloClient with the token */
    static func refresh() {
        Network.shared = Network()
    }
}

