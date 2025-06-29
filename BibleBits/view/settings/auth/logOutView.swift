import SwiftUI

struct LogOutView: View {
    @State private var isPresented = false
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
  var body: some View {
    Button("Log Out") {
      signOut()
    }
    .confirmationDialog("Are you sure you want to log out?", isPresented: $isPresented) {
      Button("Log Out", role: .destructive) {
        signOut()
        isPresented = false
      }
      Button("Cancel", role: .cancel) {
        isPresented = false
      }
    }
  }
  func signOut() {
    UserDefaults.standard.removeObject(forKey: "currentUserIdentifier")
    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    isUserLoggedIn = false
  }
}
