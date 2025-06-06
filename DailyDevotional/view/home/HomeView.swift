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
                    ForEach(homeViewModel.bibleData, id: \.id) { verse in
                        Text("\(verse.verse_start) \(verse.verse_text)")

                    }
                } header: {
                    HStack {

                        Text(homeViewModel.todayDevotional?.book ?? "")
                            .font(.subheadline)
                        Text(
                            "\(homeViewModel.todayDevotional?.chapter ?? 0):\(homeViewModel.todayDevotional?.start ?? 0)-\(homeViewModel.todayDevotional?.end ?? 0)"
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
                    Button("", systemImage: "checkmark.circle") {
                    }
                }
            }
        }

    }

}

struct MockData {
    var title = "devotional1"
    var content = "This is a sample devotional content."
    var date = Date()
    var book = "Genesis"
    var chapter = 1
    var range = "1:1-5"
    var version = "ESV"
}
