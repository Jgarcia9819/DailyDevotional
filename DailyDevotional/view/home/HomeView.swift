import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var homeViewModel = HomeViewModel.shared
    @ObservedObject var bibleService = BibleService.shared
    @FocusState private var isTextEditorFocused: Bool
    @State private var buttonTrigger: Bool = false
    var body: some View {
        NavigationStack {
            List {
                if bibleService.loading {
                    Section {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(
                                    tint: colorScheme == .dark ? .white : .blue)
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    Section {
                        homeViewModel.randomBibleData.reduce(Text("")) { result, verse in
                            result
                                + Text("\(verse.verse_start)").font(.caption)
                                .foregroundColor(.secondary).baselineOffset(3)
                                + Text(" \(verse.verse_text) ")
                        }
                        .textSelection(.enabled)
                    }
                }
                Section("Reflection") {
                    TextEditor(text: $homeViewModel.entryText)
                        .focused($isTextEditorFocused)
                        .overlay(alignment: .topLeading) {
                            if homeViewModel.entryText.isEmpty {
                                Text("Enter your text here...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }

                        }

                }

                .navigationTitle(
                    bibleService.loading
                        ? ""
                        : "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
                )

            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            isTextEditorFocused = false
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        "",
                        systemImage: homeViewModel.saved
                            ? "checkmark.circle.fill" : "checkmark.circle"
                    ) {
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
                }
            }
            .refreshable {
                homeViewModel.saved = false
                homeViewModel.entryText = ""
                await homeViewModel.fetchRandomDevotional()
                await homeViewModel.fetchRandomBibleData()
            }
        }

    }

    //because swiftdata does not play nice with MVVM architecture, we place crud functionality in the views
    func saveEntry(homeViewModel: HomeViewModel, modelContext: ModelContext, dismiss: DismissAction)
    {
        homeViewModel.saved = true
        guard let devotional = homeViewModel.randomDevotional else {
            return
        }

        let entry = Entry(
            id: UUID(),  // Generate a new UUID for the entry
            devoID: devotional.id, createdAt: Date(),
            content: homeViewModel.entryText,
            saved: true)

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
