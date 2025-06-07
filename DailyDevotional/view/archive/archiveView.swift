import SwiftData
import SwiftUI

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bibleService = BibleService.shared
    @Query(sort: \Entry.createdAt, order: .reverse) private var entries: [Entry]
    @State private var isDeleting: Bool = false

    var body: some View {
        NavigationStack {
            if entries.isEmpty {
                List {
                    Section {
                        Text("No entries found.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .navigationTitle("Archive")
                }
            } else {
                List(entries, id: \.id) { entry in
                    Section {
                        Text(entry.content)
                            .font(.body)
                            .padding(.bottom, 2)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            isDeleting = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
                .navigationTitle("Archive")
            }

        }
        .alert("Delete Entry? This cannot be undone.", isPresented: $isDeleting) {
            Button("Delete", role: .destructive) {
                if let entryToDelete = entries.first {
                    deleteEntry(entry: entryToDelete)
                }
                isDeleting = false
            }
            Button("Cancel", role: .cancel) {
                isDeleting = false
            }
        }

    }
    //because swiftdata does not play nice with MVVM architecture, we place the functions in the view
    private func deleteEntry(entry: Entry) {
        modelContext.delete(entry)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete entry: \(error)")
        }
    }
}
