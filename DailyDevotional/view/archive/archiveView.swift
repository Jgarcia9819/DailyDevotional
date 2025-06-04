import SwiftData
import SwiftUI

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bibleService: BibleService

    var body: some View {
        NavigationStack {
            List(bibleService.devotionals, id: \.id) { devotional in
                Section {
                    Text(devotional.book)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Archive")
        }

    }
}
