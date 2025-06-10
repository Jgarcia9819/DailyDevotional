import SwiftData
import SwiftUI

extension Font {
    static func customBibleTextSize(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular, design: .serif)
    }
}

struct HomeView: View {
    @AppStorage("customFontSize") var customFontSize: Double = 17
    @AppStorage("customLineSize") var customLineSize: Double = 3
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var homeViewModel = HomeViewModel.shared
    @ObservedObject var bibleService = BibleService.shared
    @FocusState private var isTextEditorFocused: Bool
    @State private var buttonTrigger: Bool = false
    @State private var showingFontEditSheet: Bool = false

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
                                + Text("\(verse.verse_start)").font(
                                    .customBibleTextSize(size: customFontSize - 4)
                                )
                                .foregroundColor(.secondary).baselineOffset(3)
                                + Text(" \(verse.verse_text) ")
                        }
                        .textSelection(.enabled)
                        .font(.customBibleTextSize(size: customFontSize))
                        .lineSpacing(customLineSize)
                    }
                }
                Section {
                    TextEditor(text: $homeViewModel.entryText)
                        .focused($isTextEditorFocused)
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

                } header: {
                    Text("Reflection")
                        .font(.system(size: 13, weight: .regular, design: .serif))
                }
            }
            .onTapGesture {
                isTextEditorFocused = false
            }
            .navigationTitle(
                bibleService.loading
                    ? ""
                    : "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
            )
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFontEditSheet) {
                FontSettingsView()
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("", systemImage: "textformat.size") {
                            showingFontEditSheet = true
                        }
                        .tint(.gray)
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
