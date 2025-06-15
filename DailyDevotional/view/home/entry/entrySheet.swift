import SwiftData
import SwiftUI

struct EntrySheetView: View {
  @ObservedObject var homeViewModel = HomeViewModel.shared
  @FocusState private var isTextEditorFocused: Bool
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme
  @State private var buttonTrigger: Bool = false

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading) {
          VStack {
            Text(
              "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
            )
            .font(.system(size: 18, weight: .regular, design: .serif))
            .padding(.vertical, 4)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          TextEditor(text: $homeViewModel.entryText)
            .focused($isTextEditorFocused)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .frame(minHeight: 200)
            .font(.system(size: 16, weight: .regular, design: .serif))
            .overlay(alignment: .topLeading) {
              if homeViewModel.entryText.isEmpty {
                Text("Your reflection here...")
                  .foregroundColor(.gray)
                  .padding(.vertical, 8)
                  .allowsHitTesting(false)
                  .font(.system(size: 16, weight: .regular, design: .serif))

              }

            }
        }
        .padding(.horizontal, 15)
        .onTapGesture {
          isTextEditorFocused = false
        }
        .toolbar {
          //ToolbarItem(placement: .navigationBarLeading) {
          //Button("Cancel") {
          //dismiss()
          //}.tint(colorScheme == .dark ? .white : .black)
          //}
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
