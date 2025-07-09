import Foundation
import Apollo

class UserSession: ObservableObject {
    /**
     * @Published means its a variable that is being watched for change because of
     * the ObservableObject class. That means isLoggedIn is a value that can change and
     * Whenever it changes, SwiftUI will automatically refresh any views that care about it.
     */
    @Published var isLoggedIn: Bool = false
    @Published var loginError: String?
    @Published var userEmail: String?
    @Published var userUsername: String?
    @Published var userFirstName: String?
    @Published var userLastName: String?
    @Published var shouldRefreshRecipes: Bool = false
    @Published var shouldRefreshTags: Bool = false
    @Published var availableTags: [String] = []

    /** Login function */
    func logIn(email: String, password: String) {
        let loginMutation = RecetteSchema.LoginMutation(email: email, password: password)

        /** Perform the login mutation using Apollo's shared network client. */
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
                    
                    /** Fetch username after login */
                    let userDetailsQuery = RecetteSchema.GetUserDetailsQuery(email: email)
                    Network.shared.apollo.fetch(query: userDetailsQuery) { result in
                        switch result {
                        case .success(let graphQLResult):
                            if let user = graphQLResult.data?.userDetails {
                                DispatchQueue.main.async {
                                    self.userUsername = user.username
                                    self.userFirstName = user.firstName
                                    self.userLastName = user.lastName
                                    
                                    UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                                    UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                                }
                            }
                        case .failure(let error):
                            print("Failed to fetch user details: \(error)")
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
                print("Successfully logged out on backend")
            case .failure(let error):
                print("Logout failed on backend: \(error.localizedDescription)")
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
    
    /** Load the tags that belong to a user */
    func loadUserTags(email: String) {
        let getUserTagsQuery = RecetteSchema.GetUserTagsQuery(email: email)
        
        Network.shared.apollo.fetch(query: getUserTagsQuery, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .success(let graphQLResult):
                if let tags = graphQLResult.data?.userTags {
                    DispatchQueue.main.async {
                        self.availableTags = tags.map { $0.name }
                    }
                }
            case .failure(let error):
                print("Failed to load tags: \(error)")
            }
        }
    }
    
    /** Add a tag to the users saved tags */
    func addTagToUser(email: String, tagName: String) {
        let addTagMutation = RecetteSchema.AddTagMutation(email: email, name: tagName)
        
        Network.shared.apollo.perform(mutation: addTagMutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    let newTag = data.addTag.name
                    DispatchQueue.main.async {
                        if !self.availableTags.contains(newTag) {
                            self.availableTags.append(newTag)
                        }
                        self.shouldRefreshTags = true
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors)")
                }
            case .failure(let error):
                print("Failed to add tag: \(error)")
            }
        }
    }
    
    /** Deletes a tag from the user's list of tags */
    func deleteTagFromUser(email: String, tagName: String) {
        let mutation = RecetteSchema.DeleteTagMutation(email: email, name: tagName)
        
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.data?.deleteTag == true {
                    DispatchQueue.main.async {
                        self.availableTags.removeAll { $0 == tagName }
                        self.shouldRefreshTags = true
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors)")
                } else {
                    print("Unexpected: deleteTag returned false or nil")
                }
            case .failure(let error):
                print("Failed to delete tag: \(error)")
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
        if UserDefaults.standard.bool(forKey: "isLoggedIn"),
           let email = UserDefaults.standard.string(forKey: "loggedInEmail") {
            
            self.userEmail = email
            self.isLoggedIn = true
            
            /** Fetch full user details on startup */
            let userDetailsQuery = RecetteSchema.GetUserDetailsQuery(email: email)
            Network.shared.apollo.fetch(query: userDetailsQuery) { result in
                switch result {
                case .success(let graphQLResult):
                    if let user = graphQLResult.data?.userDetails {
                        DispatchQueue.main.async {
                            self.userUsername = user.username
                            self.userFirstName = user.firstName
                            self.userLastName = user.lastName

                            UserDefaults.standard.set(user.username, forKey: "loggedInUsername")
                            UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                            UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                        }
                    }
                case .failure(let error):
                    print("Failed to load user details at startup: \(error)")
                }
            }
        }
    }

    
    /** Ensure that the error message from login doesnt persist into sign up or reversed*/
    func clearLoginError() {
        DispatchQueue.main.async {
            self.loginError = nil
        }
    }


}

