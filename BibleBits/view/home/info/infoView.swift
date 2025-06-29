import SwiftUI

struct InfoView: View {
  @ObservedObject var homeViewModel = HomeViewModel.shared
  var body: some View {
    Text(homeViewModel.bookInfo?.extract ?? "")
  }
}