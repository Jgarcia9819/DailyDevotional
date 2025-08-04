import StoreKit
import SwiftData
import SwiftUI

struct SettingsView: View {
  @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
  @Environment(\.modelContext) private var modelContext
  @Environment(\.requestReview) private var requestReview

  var body: some View {
    NavigationStack {
      List {
        Section {
          NavigationLink("Account Settings") {
            AccountView()
          }
        } header: {
          Text("Account")
            .font(.system(size: 13, weight: .regular, design: .serif))
        }
        Section {
          Button("Leave a Review") {
            requestReview()
          }
        }
        //Section {
          //HStack {
            //Spacer()
            //if isUserLoggedIn {
              //LogOutView()
            //} else {
              //AuthView()
                //.frame(width: 200, height: 44)
                //.cornerRadius(10)
            //}
            //Spacer()
          //}
        //}
      }
      .navigationTitle("Settings")
    }
  }

}
