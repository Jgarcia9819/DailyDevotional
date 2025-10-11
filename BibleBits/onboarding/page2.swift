import SwiftUI

enum pickerSelect: String, CaseIterable, Identifiable {
    case one = "1"
    case two = "2"

    var id: String { self.rawValue }
}

struct Page2: View {
    @AppStorage("firstAppearance") var firstAppearance = true
    @State private var imageSelection: pickerSelect = pickerSelect.one
    var body: some View {
        VStack() {
            Divider()
            Picker("", selection: $imageSelection) {
                Text("Create").tag(pickerSelect.one)
                Text("Reflect").tag(pickerSelect.two)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: .infinity)
            .padding(.top, 15)

            if imageSelection == pickerSelect.one {
                Image("refreshScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(32)
                    Divider()
                Text(
                    "Simply pull down on the screen to refresh and load a new passage of scripture."
                )
                .bold()
            } else {
                Image("reflectScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(32)
                    Divider()
                Text(
                    "Tap the write icon to bring up a reflection sheet and save your thoughts."
                )
                .bold()
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
