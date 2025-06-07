import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var homeViewModel = HomeViewModel.shared
    @FocusState private var isTextEditorFocused: Bool
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(homeViewModel.randomBibleData, id: \.id) { verse in
                        Text("\(verse.verse_start)") + Text("\(verse.verse_text)")

                    }
                } header: {
                    HStack {

                        Text(homeViewModel.randomDevotional?.book ?? "")
                            .font(.subheadline)
                        Text(
                            "\(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
                        )
                        .font(.subheadline)

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
                .navigationTitle("Today")
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
                        homeViewModel.saved = true
                        guard let devotional = homeViewModel.randomDevotional else {
                            return
                        }

                        let entry = Entry(
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
            }
            .refreshable {
                homeViewModel.saved = false
                homeViewModel.entryText = ""
                await homeViewModel.fetchRandomDevotional()
                await homeViewModel.fetchRandomBibleData()
            }
        }

    }

}
