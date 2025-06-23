import SwiftData
import SwiftUI

struct EditView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State var entry: Entry
  @State private var editedContent: String = ""
  @ObservedObject var bibleService = BibleService.shared
  @ObservedObject var homeViewModel = HomeViewModel.shared
  @ObservedObject var editViewModel = EditViewModel.shared

  var body: some View {
    NavigationStack {
      List {
        Section {
          editViewModel.editedBibleData.reduce(Text("")) { result, verse in
            result
              + Text("\(verse.verse_start)").font(.caption)
              .foregroundColor(.secondary).baselineOffset(3)
              + Text(" \(verse.verse_text) ")
          }
          .textSelection(.enabled)
          .font(.system(size: 18, weight: .regular, design: .serif))
        }
        .listRowSeparator(.hidden)
        Section {
          TextEditor(text: $entry.content)
            .font(.system(size: 16, weight: .regular, design: .serif))
            .frame(minHeight: 125)
            .scrollContentBackground(.hidden)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .font(.system(size: 16, weight: .regular, design: .serif))
            .padding(.bottom, 100)

        } header: {
          Text("Reflection")
            .font(.system(size: 13, weight: .regular, design: .serif))
        }
        .listRowSeparator(.hidden)
      }
      .listStyle(PlainListStyle())
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Update") {
            updateEntry(modelContext: modelContext)
            dismiss()
          }
        }
      }
      .navigationTitle("\(entry.book) \(entry.chapter):\(entry.start)-\(entry.end)")
    }
    .onAppear {
      Task {
        await editViewModel.getEditedBibleData(entry: entry)
      }
    }
  }

  //because swiftdata does not play nice with MVVM architecture, we place the functions in the view
  private func updateEntry(modelContext: ModelContext) {
    entry.createdAt = Date()  // Update the timestamp to current date
    do {
      try modelContext.save()
    } catch {
      print("Failed to save entry: \(error.localizedDescription)")
    }
  }
}
