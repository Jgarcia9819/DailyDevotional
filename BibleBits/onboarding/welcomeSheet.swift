import SwiftUI

struct WelcomeSheet: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      VStack {
        Divider()
        Image("iconImage")
          .resizable()
          .scaledToFit()
          .frame(width: 150, height: 150)
          .frame(maxWidth: .infinity)
          .padding(.top, 25)
          .padding(.bottom, 25)

        (Text("Bible Clips ")
          .bold()
          + Text(
            "is intended to be a place for exploration and reflection on passages of scripture all throughout the Bible."
          ))
        Spacer()

        VStack(alignment: .center) {

          NavigationLink(destination: Page1()) {
            Text("Next")
              .font(.system(size: 20))
              .frame(width: 250, height: 40)
          }
          .buttonStyle(.borderedProminent)

        }
        .frame(maxWidth: .infinity)
      }
      .padding(.horizontal, 30)
      .navigationTitle("Welcome!")
      .presentationBackground(Color(uiColor: .systemBackground))
    }
  }
}

#Preview {
  WelcomeSheet()
}
