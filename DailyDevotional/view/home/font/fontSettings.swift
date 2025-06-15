import SwiftUI

struct FontSettingsView: View {
  @AppStorage("customFontSize") var customFontSize: Double = 17
  @AppStorage("customLineSize") var customLineSize: Double = 3
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    List {
      Section {
        HStack {
        Text("Front Size")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)
        Spacer()
          Button(action: {
            if customFontSize >= 1 {
              customFontSize = customFontSize - 3
            }
          }) {
            Image(systemName: "minus")
              .frame(width: 20, height: 20)
              .foregroundColor(colorScheme == .dark ? .white : .black)
          }
          .buttonStyle(.bordered)
          .padding(.horizontal, 16)

          Button(action: {
            if customFontSize <= 36 {
              customFontSize = customFontSize + 3
            }
          }) {
            Image(systemName: "plus")
              .frame(width: 20, height: 20)
              .foregroundColor(colorScheme == .dark ? .white : .black)
          }
          .buttonStyle(.bordered)
          .padding(.horizontal, 16)
        }
      }

      Section {
        HStack {
        Text("Line Height")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)
        Spacer()
          Button(action: {
            if customLineSize >= 1 {
              customLineSize = customLineSize - 1
            }
          }) {
            Image(systemName: "minus")
              .frame(width: 20, height: 20)
              .foregroundColor(colorScheme == .dark ? .white : .black)
          }
          .buttonStyle(.bordered)
          .padding(.horizontal, 16)

          Button(action: {
            if customLineSize <= 8 {
              customLineSize = customLineSize + 1
            }
          }) {
            Image(systemName: "plus")
              .frame(width: 20, height: 20)
              .foregroundColor(colorScheme == .dark ? .white : .black)
          }
          .buttonStyle(.bordered)
          .padding(.horizontal, 16)
        }
      }
    }
    .padding(.top, 40)
    .listStyle(PlainListStyle())
  }
}
