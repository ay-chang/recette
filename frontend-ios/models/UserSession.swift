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

        Network.shared.apollo.perform(mutation: loginMutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.login {
                    AuthManager.shared.saveToken(token) // store the token securely
                    Network.refresh()

                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.userEmail = email

                        UserDefaults.standard.set(email, forKey: "loggedInEmail")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    }

                    /** Fetch user details after login */
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
    
    /** Login with google */
    func logInWithGoogle(idToken: String) {
        loginError = nil
        let m = RecetteSchema.LoginWithGoogleMutation(idToken: idToken)

        Network.shared.apollo.perform(mutation: m) { result in
            switch result {
            case .success(let res):
                guard let jwt = res.data?.loginWithGoogle else {
                    DispatchQueue.main.async { self.loginError = "Login failed" }
                    return
                }

                // 1) Save token + refresh Apollo auth header
                AuthManager.shared.saveToken(jwt)
                Network.refresh()

                // 2) Persist session flags + email
                let email = self.decodeEmail(from: jwt)
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    if let email = email {
                        self.userEmail = email
                        UserDefaults.standard.set(email, forKey: "loggedInEmail")
                    }
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }

                // 3) Fetch user details and persist them
                if let email = email {
                    let q = RecetteSchema.GetUserDetailsQuery(email: email)
                    Network.shared.apollo.fetch(query: q) { r in
                        switch r {
                        case .success(let g):
                            if let u = g.data?.userDetails {
                                DispatchQueue.main.async {
                                    self.userUsername = u.username
                                    self.userFirstName = u.firstName
                                    self.userLastName  = u.lastName
                                    UserDefaults.standard.set(u.firstName, forKey: "loggedInFirstName")
                                    UserDefaults.standard.set(u.lastName,  forKey: "loggedInLastName")
                                }
                            }
                        case .failure(let e):
                            print("Fetch user details failed:", e)
                        }
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async { self.loginError = error.localizedDescription }
            }
        }
    }
    
    /** Helper decoding function for Google login*/
    private func decodeEmail(from jwt: String) -> String? {
        let parts = jwt.split(separator: ".")
        guard parts.count >= 2 else { return nil }
        var base64 = parts[1].replacingOccurrences(of: "-", with: "+")
                              .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 { base64 += "=" }
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return (json["sub"] as? String) ?? (json["email"] as? String)
    }



    
    /** Completing sign up after user inputs code */
    func completeSignUpWithCode(email: String, code: String) {
        let mutation = RecetteSchema.CompleteSignUpWithCodeMutation(email: email, code: code)
        
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.completeSignUpWithCode {
                    /** Save token and refresh network client */
                    AuthManager.shared.saveToken(token)
                    Network.refresh()
                    
                    /** Store login info */
                    DispatchQueue.main.async {
                        self.userEmail = email
                        self.userUsername = email.split(separator: "@").first.map(String.init) ?? ""
                        self.isLoggedIn = true
                        
                        UserDefaults.standard.set(email, forKey: "loggedInEmail")
                        UserDefaults.standard.set(self.userUsername, forKey: "loggedInUsername")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        print("Sign-up login state saved")
                    }
                    
                    /** Immediately fetch user details after signup */
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
                                    
                                    print("User details fetched after sign-up")
                                }
                            } else if let errors = graphQLResult.errors {
                                print("GraphQL errors fetching user details: \(errors.map(\.message))")
                            }
                        case .failure(let error):
                            print("Failed to fetch user details after sign-up: \(error)")
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
        let logoutMutation = RecetteSchema.LogoutMutation()  // no email argument

        Network.shared.apollo.perform(mutation: logoutMutation) { result in
            switch result {
            case .success:
                print("Successfully logged out on backend")
            case .failure(let error):
                print("Logout failed on backend: \(error.localizedDescription)")
            }

            AuthManager.shared.clearToken()  // clear token
            self.clearSession()
        }
    }
    
    /** Delete User account */
    func deleteAccount(onComplete: @escaping () -> Void = {}) {
        let mutation = RecetteSchema.DeleteAccountMutation()

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.data?.deleteAccount == true {
                    print("Account successfully deleted")

                    /** Clean up local session */
                    AuthManager.shared.clearToken()
                    self.clearSession()

                    DispatchQueue.main.async {
                        onComplete()
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL Errors: \(errors.compactMap { $0.message }.joined(separator: "\n"))")
                } else {
                    print("Account deletion failed with unknown error")
                }

            case .failure(let error):
                print("Network error while deleting account: \(error.localizedDescription)")
            }
        }
    }


    
    /** Send verification code */
    func sendVerificationCode(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let mutation = RecetteSchema.SendVerificationCodeMutation(email: email, password: password)
        
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.data?.sendVerificationCode == true {
                    self.loginError = nil
                    completion(true)
                } else if let errors = graphQLResult.errors {
                    DispatchQueue.main.async {
                        self.loginError = errors.compactMap { $0.message }.joined(separator: "\n")
                        completion(false)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    
    /** Update the users first and last name */
    func updateAccountDetails(firstName: String, lastName: String, onComplete: @escaping () -> Void = {}) {
        guard let email = userEmail else { return }

        let input = RecetteSchema.AccountDetailsInput(
            firstName: .some(firstName),
            lastName: .some(lastName)
        )

        let mutation = RecetteSchema.UpdateAccountDetailsMutation(email: email, input: input)

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let _ = graphQLResult.data?.updateAccountDetails {
                    DispatchQueue.main.async {
                        self.refreshUserDetails()
                        onComplete()
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL Errors: \(errors.compactMap { $0.message }.joined(separator: "\n"))")
                }
            case .failure(let error):
                print("Network Error: \(error.localizedDescription)")
            }
        }
    }

    /** Used for when updating a users account details */
    func refreshUserDetails() {
        guard let email = userEmail else { return }

        let query = RecetteSchema.GetUserDetailsQuery(email: email)
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
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
                print("Failed to refresh user details: \(error)")
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
    func addTagToUser(tagName: String, completion: @escaping (String?) -> Void) {
        let addTagMutation = RecetteSchema.AddTagMutation(name: tagName)

        Network.shared.apollo.perform(mutation: addTagMutation) { result in
            switch result {
            case .success(let graphQLResult):
                // If server returned GraphQL errors, surface the first message
                if let firstError = graphQLResult.errors?.first {
                    completion(firstError.message)
                    return
                }

                // Success path
                if let tag = graphQLResult.data?.addTag {
                    DispatchQueue.main.async {
                        if !self.availableTags.contains(where: { $0.caseInsensitiveCompare(tag.name) == .orderedSame }) {
                            self.availableTags.append(tag.name)
                        }
                        self.shouldRefreshTags = true
                    }
                    completion(nil)
                } else {
                    completion("Unexpected server response.")
                }

            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }

    
    /** Deletes a tag from the user's list of tags */
    func deleteTagFromUser(tagName: String) {
        let mutation = RecetteSchema.DeleteTagMutation(name: tagName)
        
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
            self.userFirstName = nil
            self.userLastName = nil
            self.loginError = nil
            self.availableTags = []
            self.shouldRefreshRecipes = false
            self.shouldRefreshTags = false

            UserDefaults.standard.removeObject(forKey: "loggedInEmail")
            UserDefaults.standard.removeObject(forKey: "loggedInUsername")
            UserDefaults.standard.removeObject(forKey: "loggedInFirstName")
            UserDefaults.standard.removeObject(forKey: "loggedInLastName")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }

    
    /** Loading in user sessions */
    func loadSavedSession() {
        let persistedToken = AuthManager.shared.jwtToken

        // Ensure we have a token first (see fix #1 above)
        guard let token = AuthManager.shared.jwtToken, !token.isEmpty else {
            self.isLoggedIn = false
            return
        }

        // Make sure Apollo has the Authorization header
        AuthManager.shared.saveToken(token)   // this also calls Network.refresh()

        // Get email: prefer saved value, otherwise decode from the JWT
        let savedEmail = UserDefaults.standard.string(forKey: "loggedInEmail")
        let email = savedEmail ?? decodeEmail(from: token)

        DispatchQueue.main.async {
            self.isLoggedIn = true
            if let email = email {
                self.userEmail = email
                if savedEmail == nil {
                    UserDefaults.standard.set(email, forKey: "loggedInEmail")
                }
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            }
        }

        // Fetch user details so first/last name are populated after app launch
        if let email = email {
            let userDetailsQuery = RecetteSchema.GetUserDetailsQuery(email: email)
            Network.shared.apollo.fetch(query: userDetailsQuery) { result in
                switch result {
                case .success(let graphQLResult):
                    if let user = graphQLResult.data?.userDetails {
                        DispatchQueue.main.async {
                            self.userUsername = user.username
                            self.userFirstName = user.firstName
                            self.userLastName  = user.lastName

                            UserDefaults.standard.set(user.username,  forKey: "loggedInUsername")
                            UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                            UserDefaults.standard.set(user.lastName,  forKey: "loggedInLastName")
                        }
                    } else if let errors = graphQLResult.errors {
                        print("GraphQL errors while fetching user details:", errors.map(\.message))
                    }
                case .failure(let error):
                    print("Failed to load user details at startup:", error)
                    // Optional: fall back to cached names if present
                    DispatchQueue.main.async {
                        if (self.userFirstName ?? "").isEmpty {
                            self.userFirstName = UserDefaults.standard.string(forKey: "loggedInFirstName")
                        }
                        if (self.userLastName ?? "").isEmpty {
                            self.userLastName = UserDefaults.standard.string(forKey: "loggedInLastName")
                        }
                    }
                }
            }
        }
    }


    
    /** Ensure that the error message from login doesnt persist into sign up or reversed */
    func clearLoginError() {
        DispatchQueue.main.async {
            self.loginError = nil
        }
    }


}

