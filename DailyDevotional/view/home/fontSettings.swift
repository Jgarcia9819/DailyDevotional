import SwiftUI

struct FontSettingsView: View {
    @AppStorage("customFontSize") var customFontSize: Double = 17
    @AppStorage("customLineSize") var customLineSize: Double = 3

    var body: some View {
        List {
            Section {
                HStack {
                    Button("", systemImage: "minus") {
                        if customFontSize >= 1 {
                            customFontSize = customFontSize - 3
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.black)
                    Spacer()
                    Button("", systemImage: "plus") {
                        if customFontSize <= 36 {
                            customFontSize = customFontSize + 3
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.black)
                }
            } header: {
                Text("Front Size")
                    .font(.system(size: 13, weight: .regular, design: .serif))
            }
            Section {
                HStack {
                    Button("", systemImage: "minus") {
                        if customLineSize >= 1 {
                            customLineSize = customLineSize - 1
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.black)
                    Spacer()
                    Button("", systemImage: "plus") {
                        if customLineSize <= 8 {
                            customLineSize = customLineSize + 1
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.black)
                }
            } header: {
                Text("Line Height")
                    .font(.system(size: 13, weight: .regular, design: .serif))
            }
        }
    }
}
