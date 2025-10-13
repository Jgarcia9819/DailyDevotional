import SwiftUI

struct Page1: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            Divider()
            if colorScheme == .dark {
                Image("toolbarScreenDark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                    .cornerRadius(32)
            } else {
                Image("toolbarScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                    .cornerRadius(32)
            }
            Divider()
            Text(
                "Tap the box to view saved passages and reflections.  Tap the bookmark to save a passage.  Tap the play button to listen to the audio version of the passage."
            )
            .font(.system(size: 20, weight: .regular, design: .serif))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 15)
            Spacer()

            VStack(alignment: .center) {

                NavigationLink(destination: Page2()) {
                    Text("Next")
                        .font(.system(size: 20))
                        .frame(width: 250, height: 40)
                }
                .buttonStyle(.borderedProminent)

            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 30)
        .navigationTitle("Make your mark!")
    }
}
