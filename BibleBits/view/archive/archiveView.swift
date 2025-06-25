import SwiftData
import SwiftUI

enum pickerSelection {
  case entries
  case savedPassages
}

struct ArchiveView: View {
  @Environment(\.modelContext) private var modelContext
  @ObservedObject var bibleService = BibleService.shared
  @Query(sort: \Entry.createdAt, order: .reverse) private var entries: [Entry]
  @Query(sort: \Saved.createdAt, order: .reverse) private var savedPassagesQuery: [Saved]
  @State private var isDeletingEntry: Bool = false
  @State private var isDeletingSavedPassage: Bool = false
  @State private var isShowingEditView: Bool = false
  @State private var isShowingReadView: Bool = false
  @State private var entryToEdit: Entry? = nil
  @State private var entryToDelete: Entry? = nil
  @State private var savedToDelete: Saved? = nil
  @State private var savedToEdit: Saved? = nil
  @State private var selectedArchiveTab: pickerSelection = .entries

  var body: some View {
    NavigationStack {
      if entries.isEmpty && savedPassagesQuery.isEmpty {
        List {
          Section {
            Text("No saved items yet")
              .font(.headline)
              .foregroundColor(.gray)

          }
        }
        .navigationTitle("Archive")

      } else {
        List {
          if selectedArchiveTab == pickerSelection.entries {
            if entries.isEmpty {
              Section {
                Text("No entries yet")
                  .font(.system(size: 16, weight: .light, design: .serif))
                  .foregroundColor(.gray)
              }
            } else {
              ForEach(entries, id: \.id) { entry in
                Section {
                  Text(entry.content)
                    .padding(.bottom, 2)
                    .font(.system(size: 16, weight: .regular, design: .serif))

                } header: {
                  HStack {
                    Text(
                      "\(entry.book) \(entry.chapter):\(entry.start)-\(entry.end)"
                    )
                    Spacer()
                    Text(entry.createdAt, style: .date)
                      .foregroundColor(.secondary)
                      .font(.system(size: 13, weight: .regular, design: .serif))
                  }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                  Button(role: .destructive) {
                    isDeletingEntry = true
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
          }
          if selectedArchiveTab == pickerSelection.savedPassages {
            ForEach(savedPassagesQuery, id: \.id) { saved in
              Section {
                HStack {
                  Text(
                    "\(saved.book) \(saved.chapter):\(saved.start)-\(saved.end)"
                  )
                }
              } header: {
                Text(saved.createdAt, style: .date)
                  .foregroundColor(.secondary)
                  .font(.system(size: 13, weight: .regular, design: .serif))

              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  isDeletingSavedPassage = true
                  savedToDelete = saved
                } label: {
                  Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                Button {
                  isShowingReadView = true
                  DispatchQueue.main.async {
                    savedToEdit = saved
                  }
                } label: {
                  Label("Read", systemImage: "book")
                }
              }
            }
          }
        }
        .navigationTitle("Archive")
        .toolbar {
          ToolbarItem {
            Picker("Selection", selection: $selectedArchiveTab) {
              Text("Entries").tag(pickerSelection.entries)
              Text("Saved").tag(pickerSelection.savedPassages)
            }
            .pickerStyle(.segmented)

          }
        }
      }

    }

    .sheet(isPresented: $isShowingEditView) {
      if let entryToEdit = entryToEdit {
        EditView(entry: entryToEdit)
      }
    }
    .sheet(isPresented: $isShowingReadView) {
      if let savedToEdit = savedToEdit {
        ReadView(savedPassage: savedToEdit)
      }
    }
    .alert("Delete Entry? This cannot be undone.", isPresented: $isDeletingEntry) {
      Button("Delete", role: .destructive) {
        if let entryToDelete = entryToDelete {
          deleteEntry(entry: entryToDelete)
        }
        isDeletingEntry = false
      }
      Button("Cancel", role: .cancel) {
        isDeletingEntry = false
      }
    }
    .alert("Delete Saved Passage? This cannot be undone.", isPresented: $isDeletingSavedPassage) {
      Button("Delete", role: .destructive) {
        if let savedToDelete = savedToDelete {
          deleteSavedPassage(saved: savedToDelete)
        }
      }
      Button("Cancel", role: .cancel) {
        isDeletingSavedPassage = false
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
  private func deleteSavedPassage(saved: Saved) {
    modelContext.delete(saved)
    do {
      try modelContext.save()
    } catch {
      print("Failed to delete saved passage: \(error)")
    }
  }
}
