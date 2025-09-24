import SwiftData
import SwiftUI

struct ReadView: View {
  @AppStorage("fontFamily") private var fontFamily: FontFamily = .serif
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State var savedPassage: Saved
  @ObservedObject var bibleService = BibleService.shared
  @ObservedObject var homeViewModel = HomeViewModel.shared
  @ObservedObject var readViewModel = ReadViewModel.shared

  var body: some View {
    NavigationStack {
      List {
        Section {
          readViewModel.editedBibleData.reduce(Text("")) { result, verse in
            result
              + Text("\(verse.verse_start)").font(.caption)
              .foregroundColor(.secondary).baselineOffset(3)
              + Text(" \(verse.verse_text) ")
          }
          .textSelection(.enabled)
          .font(.system(size: 18, weight: .regular, design: fontFamily.fontDesign))
        }
        .listRowSeparator(.hidden)
      }
      .listStyle(PlainListStyle())
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
          .font(.system(size: 13, weight: .regular, design: fontFamily.fontDesign))
        }
      }
      .navigationTitle("\(savedPassage.book) \(savedPassage.chapter):\(savedPassage.start)-\(savedPassage.end)")
    }
    .onAppear {
      Task {
        await readViewModel.getEditedBibleData(saved: savedPassage)
      }
    }

  }
}
