import SwiftData
import SwiftUI

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bibleService = BibleService.shared
    @Query(sort: \Entry.createdAt, order: .reverse) private var entries: [Entry]
    @State private var isDeleting: Bool = false
    @State private var isShowingEditView: Bool = false
    @State private var entryToEdit: Entry? = nil
    @State private var entryToDelete: Entry? = nil

    var body: some View {
        NavigationStack {
            if entries.isEmpty {
                List {
                    Section {
                        Text("No saved entries yet")
                            .font(.headline)
                            .foregroundColor(.gray)

                    }
                }
                .navigationTitle("Archive")

            } else {
                List(entries, id: \.id) { entry in
                    Section {
                        Text(entry.content)
                            .padding(.bottom, 2)
                            .font(.system(size: 16, weight: .regular, design: .serif))

                    } header: {
                        HStack {
                            Text("\(entry.book) \(entry.chapter):\(entry.start)-\(entry.end)")
                            Spacer()
                            Text(entry.createdAt, style: .date)
                                .foregroundColor(.secondary)
                                .font(.system(size: 13, weight: .regular, design: .serif))
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        HStack {
                            Button(role: .destructive) {
                                isDeleting = true
                                entryToDelete = entry
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            Button {
                                isShowingEditView = true
                                DispatchQueue.main.async {
                                    entryToEdit = entry
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                }
                .navigationTitle("Archive")
            }
        }

        .sheet(isPresented: $isShowingEditView) {
            if let entryToEdit = entryToEdit {
                EditView(entry: entryToEdit)
            }
        }
        .alert("Delete Entry? This cannot be undone.", isPresented: $isDeleting) {
            Button("Delete", role: .destructive) {
                if let entryToDelete = entryToDelete {
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
