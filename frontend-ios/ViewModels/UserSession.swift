import Foundation

class UserSession: ObservableObject {
    /**
     * @Published means its a variable that is being watched for change because of
     * the ObservableObject class. That means isLoggedIn is a value that can change and
     * Whenever it changes, SwiftUI will automatically refresh any views that care about it.
     */
    @Published var isLoggedIn: Bool = false
    @Published var isAuthLoading: Bool = false
    @Published var loginError: String?
    @Published var userEmail: String?
    @Published var userUsername: String?
    @Published var userFirstName: String?
    @Published var userLastName: String?
    @Published var shouldRefreshRecipes: Bool = false
    @Published var shouldRefreshTags: Bool = false
    @Published var availableTags: [String] = []

    /** Wire up 401 auto-logout */
    func setupUnauthorizedHandler() {
        RecetteAPI.shared.onUnauthorized = { [weak self] in
            self?.logOut()
        }
    }

    /** Helper to save both tokens from an auth response */
    private func saveTokens(from response: AuthResponse) {
        AuthManager.shared.saveToken(response.token)
        AuthManager.shared.saveRefreshToken(response.refreshToken)
    }

    /** Login function */
    func logIn(email: String, password: String) {
        DispatchQueue.main.async { self.isAuthLoading = true }
        Task {
            defer { DispatchQueue.main.async { self.isAuthLoading = false } }
            do {
                let response = try await AuthService.shared.login(email: email, password: password)

                // Store tokens and refresh network
                saveTokens(from: response)

                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.userEmail = email

                    UserDefaults.standard.set(email, forKey: "loggedInEmail")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }

                // Fetch user details after login
                Task {
                    do {
                        let user = try await UserService.shared.getCurrentUser()
                        DispatchQueue.main.async {
                            self.userUsername = user.username
                            self.userFirstName = user.firstName
                            self.userLastName = user.lastName

                            UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                            UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                        }
                    } catch {
                        print("Failed to fetch user details: \(error)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                }
            }
        }
    }
    
    /** Login with google */
    func logInWithGoogle(idToken: String) {
        loginError = nil
        DispatchQueue.main.async { self.isAuthLoading = true }

        Task {
            defer { DispatchQueue.main.async { self.isAuthLoading = false } }
            do {
                let response = try await AuthService.shared.loginWithGoogle(idToken: idToken)

                // 1) Save tokens
                saveTokens(from: response)

                // 2) Persist session flags + email
                let email = self.decodeEmail(from: response.token)
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    if let email = email {
                        self.userEmail = email
                        UserDefaults.standard.set(email, forKey: "loggedInEmail")
                    }
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }

                // 3) Fetch user details and persist them
                Task {
                    do {
                        let user = try await UserService.shared.getCurrentUser()
                        DispatchQueue.main.async {
                            self.userUsername = user.username
                            self.userFirstName = user.firstName
                            self.userLastName = user.lastName
                            UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                            UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                        }
                    } catch {
                        print("Fetch user details failed:", error)
                    }
                }
            } catch {
                DispatchQueue.main.async { self.loginError = error.localizedDescription }
            }
        }
    }
    
    /** Login with Apple */
    func logInWithApple(idToken: String) {
        loginError = nil
        DispatchQueue.main.async { self.isAuthLoading = true }

        Task {
            defer { DispatchQueue.main.async { self.isAuthLoading = false } }
            do {
                let response = try await AuthService.shared.loginWithApple(idToken: idToken)

                saveTokens(from: response)

                let email = self.decodeEmail(from: response.token)
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    if let email = email {
                        self.userEmail = email
                        UserDefaults.standard.set(email, forKey: "loggedInEmail")
                    }
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }

                Task {
                    do {
                        let user = try await UserService.shared.getCurrentUser()
                        DispatchQueue.main.async {
                            self.userUsername = user.username
                            self.userFirstName = user.firstName
                            self.userLastName = user.lastName
                            UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                            UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                        }
                    } catch {
                        print("Fetch user details failed:", error)
                    }
                }
            } catch {
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
        DispatchQueue.main.async { self.isAuthLoading = true }
        Task {
            defer { DispatchQueue.main.async { self.isAuthLoading = false } }
            do {
                let response = try await AuthService.shared.completeSignUp(email: email, code: code)

                /** Save tokens and refresh network client */
                saveTokens(from: response)

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
                Task {
                    do {
                        let user = try await UserService.shared.getCurrentUser()
                        DispatchQueue.main.async {
                            self.userUsername = user.username
                            self.userFirstName = user.firstName
                            self.userLastName = user.lastName

                            UserDefaults.standard.set(user.username, forKey: "loggedInUsername")
                            UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                            UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")

                            print("User details fetched after sign-up")
                        }
                    } catch {
                        print("Failed to fetch user details after sign-up: \(error)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                }
            }
        }
    }



    /** Logout function, also clears out session variables through clearSession()*/
    func logOut() {
        AuthManager.shared.clearToken()
        self.clearSession()
    }
    
    /** Delete User account */
    func deleteAccount(onComplete: @escaping () -> Void = {}) {
        Task {
            do {
                try await UserService.shared.deleteCurrentUser()
                print("Account successfully deleted")

                AuthManager.shared.clearToken()
                self.clearSession()

                DispatchQueue.main.async {
                    onComplete()
                }
            } catch {
                print("Network error while deleting account: \(error)")
            }
        }
    }


    
    /** Send verification code */
    func sendVerificationCode(email: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async { self.isAuthLoading = true }
        Task {
            defer { DispatchQueue.main.async { self.isAuthLoading = false } }
            do {
                try await AuthService.shared.sendVerificationCode(email: email, password: password)
                DispatchQueue.main.async {
                    self.loginError = nil
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    
    /** Update the users first and last name */
    func updateAccountDetails(firstName: String, lastName: String, onComplete: @escaping () -> Void = {}) {
        Task {
            do {
                let user = try await UserService.shared.updateCurrentUser(firstName: firstName, lastName: lastName)
                DispatchQueue.main.async {
                    self.userFirstName = user.firstName
                    self.userLastName = user.lastName
                    UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                    UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                    onComplete()
                }
            } catch {
                print("Network Error: \(error)")
            }
        }
    }

    /** Used for when updating a users account details */
    func refreshUserDetails() {
        Task {
            do {
                let user = try await UserService.shared.getCurrentUser()
                DispatchQueue.main.async {
                    self.userUsername = user.username
                    self.userFirstName = user.firstName
                    self.userLastName = user.lastName

                    UserDefaults.standard.set(user.username, forKey: "loggedInUsername")
                    UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                    UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                }
            } catch {
                print("Failed to refresh user details: \(error)")
            }
        }
    }

    
    /** Load the tags that belong to a user */
    func loadUserTags(email: String) {
        Task {
            do {
                let tags = try await TagService.shared.getMyTags()
                DispatchQueue.main.async {
                    self.availableTags = tags.map { $0.name }
                }
            } catch {
                print("Failed to load tags: \(error)")
            }
        }
    }
    
    /** Add a tag to the users saved tags */
    func addTagToUser(tagName: String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                let tag = try await TagService.shared.createTag(name: tagName)
                DispatchQueue.main.async {
                    if !self.availableTags.contains(where: { $0.caseInsensitiveCompare(tag.name) == .orderedSame }) {
                        self.availableTags.append(tag.name)
                    }
                    self.shouldRefreshTags = true
                }
                completion(nil)
            } catch {
                completion(error.localizedDescription)
            }
        }
    }

    
    /** Deletes a tag from the user's list of tags */
    func deleteTagFromUser(tagName: String) {
        Task {
            do {
                try await TagService.shared.deleteTag(name: tagName)
                DispatchQueue.main.async {
                    self.availableTags.removeAll { $0 == tagName }
                    self.shouldRefreshTags = true
                }
            } catch {
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
        guard let token = AuthManager.shared.jwtToken, !token.isEmpty else {
            self.isLoggedIn = false
            return
        }

        // Ensure token is saved (migrates from UserDefaults if needed)
        AuthManager.shared.saveToken(token)

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
        Task {
            do {
                let user = try await UserService.shared.getCurrentUser()
                DispatchQueue.main.async {
                    self.userUsername = user.username
                    self.userFirstName = user.firstName
                    self.userLastName = user.lastName

                    UserDefaults.standard.set(user.username, forKey: "loggedInUsername")
                    UserDefaults.standard.set(user.firstName, forKey: "loggedInFirstName")
                    UserDefaults.standard.set(user.lastName, forKey: "loggedInLastName")
                }
            } catch {
                print("Failed to load user details at startup:", error)
                // Fall back to cached names if present
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


    
    /** Ensure that the error message from login doesnt persist into sign up or reversed */
    func clearLoginError() {
        DispatchQueue.main.async {
            self.loginError = nil
        }
    }


}

