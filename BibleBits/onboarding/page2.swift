import SwiftUI

enum pickerSelect: String, CaseIterable, Identifiable {
    case one = "1"
    case two = "2"

    var id: String { self.rawValue }
}

struct Page2: View {
    @AppStorage("firstAppearance") var firstAppearance = true
    @State private var imageSelection: pickerSelect = pickerSelect.one
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack() {
            Divider()
            Picker("", selection: $imageSelection) {
                Text("Create").tag(pickerSelect.one)
                Text("Reflect").tag(pickerSelect.two)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: .infinity)
            .padding(.top, 50)

            if imageSelection == pickerSelect.one {
                if colorScheme == .dark {
                    Image("refreshScreenDark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(32)
                } else {
                Image("refreshScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(32)
                }
                    Divider()
                Text(
                    "Simply pull down on the screen to refresh and load a new passage of scripture."
                )
                .font(.system(size: 20, weight: .regular, design: .serif))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
            } else {
                if colorScheme == .dark {
                    Image("reflectScreenDark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(32)
                } else {
                Image("reflectScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(32)
                }
                    Divider()
                Text(
                    "Tap the write icon to bring up a reflection sheet and save your thoughts."
                )
                .font(.system(size: 20, weight: .regular, design: .serif))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
            }

            Spacer()

            VStack(alignment: .center) {

                Button(action: {
                    firstAppearance = false
                }) {
                    Text("Enjoy!")
                        .font(.system(size: 20))
                        .frame(width: 250, height: 40)
                }
                .buttonStyle(.borderedProminent)

            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 30)
        .navigationTitle("Journal & Reflect!")
    }
}
