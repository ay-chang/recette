import Foundation
import Apollo

class UserSession: ObservableObject {
    // @Published means its a variable that is being watched for change because of
    // the ObservableObject class. That means isLoggedIn is a value that can change and
    // Whenever it changes, SwiftUI will automatically refresh any views that care about it.
    @Published var isLoggedIn: Bool = false
    @Published var loginError: String?
    @Published var userEmail: String?
    @Published var userUsername: String?
    @Published var shouldRefreshRecipes: Bool = false // used to refresh the recipe list 

    /** Login function */
    func logIn(email: String, password: String) {
        let loginMutation = RecetteSchema.LoginMutation(email: email, password: password)

        Network.shared.apollo.perform(mutation: loginMutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.login {
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.userEmail = email
                        
                        /**
                         * UserDefaults is a built-in key-value storage system in iOS used for saving small, persistent data like:
                         * Booleans (true / false)
                         * Strings (like emails or tokens)
                         * Integers, arrays, etc.*
                         */
                        UserDefaults.standard.set(email, forKey: "loggedInEmail")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    }
                    
                    // Fetch username after login
                    let usernameQuery = RecetteSchema.GetUsernameQuery(email: email)
                    Network.shared.apollo.fetch(query: usernameQuery) { result in
                        switch result {
                        case .success(let graphQLResult):
                            if let username = graphQLResult.data?.getUsername {
                                DispatchQueue.main.async {
                                    self.userUsername = username
                                    UserDefaults.standard.set(username, forKey: "loggedInUsername")
                                }
                            }
                        case .failure(let error):
                            print("Failed to fetch username: \(error)")
                        }
                    }
                } else if let errors = graphQLResult.errors {
                    DispatchQueue.main.async {
                        self.loginError = errors.compactMap { $0.message }.joined(separator: "\n")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                }
            }
        }
    }

    /** Logout function, also clears out session variables through clearSession()*/
    func logOut() {
        guard let email = userUsername else {
            print("No email to log out with.")
            clearSession()
            return
        }
        
        let logoutMutation = RecetteSchema.LogoutMutation(email: email)
        Network.shared.apollo.perform(mutation: logoutMutation) { result in
            switch result {
            case .success:
                print("✅ Successfully logged out on backend")
            case .failure(let error):
                print("❌ Logout failed on backend: \(error.localizedDescription)")
            }
            
            self.clearSession()
        }
    }
    
    /** Sign up function*/
    func signUp(email: String, password: String){
        let signUpMutation = RecetteSchema.SignUpMutation(email: email, password: password)
        
        Network.shared.apollo.perform(mutation: signUpMutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let user = graphQLResult.data?.signUp {
                    DispatchQueue.main.async {
                        self.userEmail = user.email
                        self.userUsername = user.username
                        self.isLoggedIn = true
                        UserDefaults.standard.set(user.email, forKey: "loggedInEmail")
                        UserDefaults.standard.set(user.username, forKey: "loggedInUsername")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    }
                } else if let errors = graphQLResult.errors {
                    DispatchQueue.main.async {
                        self.loginError = errors.compactMap { $0.message }.joined(separator: "\n")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                }
            }
        }
    
    }
        
    /** Helper function to reset session variables*/
    private func clearSession() {
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.userEmail = nil
            self.userUsername = nil
            self.loginError = nil
            
            // Clear persisted session
            UserDefaults.standard.removeObject(forKey: "loggedInEmail")
            UserDefaults.standard.removeObject(forKey: "loggedInUsername")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }
    
    /** Loading in user sessions */
    func loadSavedSession() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            self.userEmail = UserDefaults.standard.string(forKey: "loggedInEmail")
            self.userUsername = UserDefaults.standard.string(forKey: "loggedInUsername")
            self.isLoggedIn = true
        }
    }

}

