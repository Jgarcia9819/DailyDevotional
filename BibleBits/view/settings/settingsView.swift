import StoreKit
import SwiftData
import SwiftUI

struct SettingsView: View {
  @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
  @Environment(\.modelContext) private var modelContext
  @Environment(\.requestReview) private var requestReview
  @AppStorage("fontFamily") private var fontFamily: FontFamily = .serif

  var body: some View {
    NavigationStack {
      List {
        Section {
          NavigationLink("Account Settings") {
            AccountView()
          }
        } header: {
          Text("Account")
            .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
        }
        Section {
          Button("Leave a Review") {
            requestReview()
          }
          .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
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
      .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
    }
  }

}
