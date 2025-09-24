import SwiftUI

enum FontFamily: String, CaseIterable{
  case system = "System"
  case rounded = "Rounded"
  case serif = "Serif"
  case monospaced = "Monospaced"
  
  var fontDesign: Font.Design {
    switch self {
    case .system:
      return .default
    case .rounded:
      return .rounded
    case .serif:
      return .serif
    case .monospaced:
      return .monospaced
    }
  }
}


struct FontSettingsView: View {
  @AppStorage("fontSize") private var fontSize: Double = 24
  @AppStorage("lineHeight") private var lineHeight: Double = 4
  @AppStorage("lineSpacing") private var lineSpacing: Double = 8
  @AppStorage("fontFamily") private var fontFamily: FontFamily = .serif
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack() {

      VStack(alignment: .leading) {
        HStack() {
        Text("Font Family")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)
          Spacer()

        Picker("Font Family", selection: $fontFamily) {
          ForEach(FontFamily.allCases, id: \.self) { family in
            Text(family.rawValue)
          }
        }
        }
      }
      .padding(.top, 8)
      .padding(16)

      VStack(alignment: .leading) {
        Text("Font Size")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)

        Slider(value: $fontSize, in: 1...36, step: 3) {
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

        Slider(value: $lineHeight, in: 1...8, step: 1) {
          Text("Line Height")
            .font(.system(size: 16, weight: .regular, design: .serif))
            .padding(.leading, 16)
        }
      }
      .padding(16)

       VStack(alignment: .leading) {
        Text("Line Spacing")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)

        Slider(value: $lineSpacing, in: 1...8, step: 1) {
          Text("Line Spacing")
            .font(.system(size: 16, weight: .regular, design: .serif))
            .padding(.leading, 16)
        }
      }
      .padding(16)

    }
  }
}

