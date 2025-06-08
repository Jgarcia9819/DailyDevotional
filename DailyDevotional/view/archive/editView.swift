import SwiftData
import SwiftUI

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var entry: Entry
    @State private var editedContent: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Content") {
                    TextEditor(text: $entry.content)

                }
            }
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
