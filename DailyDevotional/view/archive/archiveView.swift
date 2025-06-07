import SwiftData
import SwiftUI

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bibleService = BibleService.shared
    @Query(sort: \Entry.createdAt, order: .reverse) private var entries: [Entry]

    var body: some View {
        NavigationStack {
            List(entries, id: \.devoID) { entry in
                VStack(alignment: .leading) {
                    Text(entry.content)
                        .font(.body)
                        .padding(.bottom, 2)
                }
            }
            .navigationTitle("Archive")
        }

    }
}
