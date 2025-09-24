import StoreKit
import SwiftData
import SwiftUI

struct SettingsView: View {
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
        Section {
          SupportButton()
        }
      }
      .navigationTitle("Settings")
      .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
    }
  }

}
