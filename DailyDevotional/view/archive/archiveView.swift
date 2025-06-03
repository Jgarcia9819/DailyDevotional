import SwiftData
import SwiftUI

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Genesis 1:1-5 (ESV)")
                        .font(.subheadline)
                }
            }

        }

    }
}
