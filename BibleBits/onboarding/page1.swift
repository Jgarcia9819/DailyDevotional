import SwiftUI

struct Page1: View {
    var body: some View {
        VStack() {
            Divider()
            Image("toolbarScreen")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .frame(maxWidth: .infinity)
                .padding(.top, 15)
                .cornerRadius(32)
                Divider()
                 Text(
                    "Tap the box to view saved passages and reflections.  Tap the bookmark to save a passage.  Tap the play button to listen to the audio version of the passage."
                )
                .bold()
                .padding(.top, -75)
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
