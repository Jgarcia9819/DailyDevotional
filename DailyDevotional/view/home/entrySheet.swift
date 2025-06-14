import SwiftData
import SwiftUI

struct EntrySheetView: View {
  @ObservedObject var homeViewModel = HomeViewModel.shared
  @FocusState private var isTextEditorFocused: Bool
  @Environment(\.dismiss) private var dismiss
  @State private var buttonTrigger: Bool = false
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    NavigationStack {
      ScrollView {
      Section {
        TextEditor(text: $homeViewModel.entryText)
          .focused($isTextEditorFocused)
          .frame(minHeight: 200)
          .font(.system(size: 16, weight: .regular, design: .serif))
          .overlay(alignment: .topLeading) {
            if homeViewModel.entryText.isEmpty {
              Text("Enter your text here...")
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .allowsHitTesting(false)
                .font(.system(size: 16, weight: .regular, design: .serif))

            }

          }
          .padding(.bottom, 100)
      }
      .onTapGesture {
        isTextEditorFocused = false
      }
      .navigationTitle("Reflection")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }.tint(colorScheme == .dark ? .white : .black)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveEntry(
              homeViewModel: homeViewModel, modelContext: modelContext,
              dismiss: dismiss)
            isTextEditorFocused = false
            buttonTrigger.toggle()
          }
          .disabled(homeViewModel.entryText.isEmpty)
          .sensoryFeedback(
            .success,
            trigger: buttonTrigger
          )
          .tint(colorScheme == .dark ? .white : .black)
          }
        }
      }
    }
  }

  func saveEntry(homeViewModel: HomeViewModel, modelContext: ModelContext, dismiss: DismissAction) {
    homeViewModel.saved = true
    guard let devotional = homeViewModel.randomDevotional else {
      return
    }

    let entry = Entry(
      id: UUID(),  // Generate a new UUID for the entry
      devoID: devotional.id,
      createdAt: Date(),
      content: homeViewModel.entryText,
      saved: true,
      book: devotional.book,
      chapter: devotional.chapter,
      start: devotional.start,
      end: devotional.end)
    print(devotional.book, devotional.chapter)

    modelContext.insert(entry)
    do {

      try modelContext.save()
      print("Entry saved successfully")
      homeViewModel.entryText = ""
    } catch {
      print("Error saving entry: \(error)")
    }
    dismiss()
  }
}
