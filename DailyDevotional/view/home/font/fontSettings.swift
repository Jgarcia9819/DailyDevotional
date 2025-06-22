import SwiftUI

struct FontSettingsView: View {
  @AppStorage("customFontSize") var customFontSize: Double = 17
  @AppStorage("customLineSize") var customLineSize: Double = 3
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        Text("Font Size")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)

        Slider(value: $customFontSize, in: 1...36, step: 3) {
          Text("Font Size")
            .font(.system(size: 16, weight: .regular, design: .serif))
            .padding(.leading, 16)
        }
      }
      .padding(16)

      VStack(alignment: .leading) {
        Text("Line Height")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)

        Slider(value: $customLineSize, in: 1...8, step: 1) {
          Text("Line Height")
            .font(.system(size: 16, weight: .regular, design: .serif))
            .padding(.leading, 16)
        }
      }
      .padding(16)

    }
  }
}
