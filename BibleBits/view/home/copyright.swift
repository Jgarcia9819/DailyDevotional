import SwiftUI

struct CopyrightView: View {
  @AppStorage("selectedVersion") var selectedVersion: String = "ENGESV"
  var body: some View {
    VStack(alignment: .leading) {
    Text(
      RawBibleData.bibleCopyrights.first { $0["abbr"] == selectedVersion }?["copyright"] ?? ""
    )
      .font(.caption)
      .foregroundColor(.secondary)
    }
    .padding(.horizontal, 16)
  }
}
