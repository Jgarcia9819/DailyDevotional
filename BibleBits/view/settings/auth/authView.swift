import AuthenticationServices
import SwiftData
import SwiftUI

struct AuthView: View {
  @Environment(\.modelContext) private var modelContext
  @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false

  var body: some View {
    SignInWithAppleButton(.signIn) { request in
      request.requestedScopes = [.fullName, .email]
    } onCompletion: { result in
      switch result {
      case .success(let authResults):
        print("Sign in with Apple successful: \(authResults)")
        handleSuccessfulLogin(with: authResults)
      case .failure(let error):
        print("Sign in with Apple failed: \(error)")
        handleLoginError(with: error)
      }
    }
    .frame(width: 200, height: 44)
    .cornerRadius(10)
  }
  private func handleSuccessfulLogin(with authorization: ASAuthorization) {
    if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      print(userCredential.user)

      if userCredential.authorizedScopes.contains(.fullName) {
        print(userCredential.fullName?.givenName ?? "No given name")
      }

      if userCredential.authorizedScopes.contains(.email) {
        print(userCredential.email ?? "No email")
      }
      saveUser(with: userCredential)
      isUserLoggedIn = true
    }
  }

  private func handleLoginError(with error: Error) {
    print("Could not authenticate: \(error.localizedDescription)")
  }

  private func saveUser(with userCredential: ASAuthorizationAppleIDCredential) {
    // Check if user already exists

    let userId = userCredential.user
    let fetchDescriptor = FetchDescriptor<User>(
      predicate: #Predicate<User> { user in
        (user.id ?? "") == userId
      }
    )

    do {
      let existingUsers = try modelContext.fetch(fetchDescriptor)

      if existingUsers.isEmpty {
        // User doesn't exist, create new one
        let user = User(
          id: userCredential.user,
          name: userCredential.fullName?.givenName,
          email: userCredential.email
        )
        print("Creating new user: \(user)")
        modelContext.insert(user)
        try modelContext.save()
      }

      // Store user identifier in UserDefaults for session management
      UserDefaults.standard.set(userCredential.user, forKey: "currentUserIdentifier")
      UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
      isUserLoggedIn = true

    } catch {
      print("Error handling user: \(error)")
    }
  }

}
