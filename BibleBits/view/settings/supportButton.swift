import SwiftUI


struct SupportButton: View {
  @AppStorage("fontFamily") private var fontFamily: FontFamily = .serif
@Environment(\.openURL) var openURL

  var body: some View {
    Button("Contact Support") {
        openURL(URL(string: "mailto:support@passagesjournal.com")!)
    }
    .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
  }
}