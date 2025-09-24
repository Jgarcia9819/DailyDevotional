import SwiftData
import SwiftUI

struct AccountView: View {
    @AppStorage("fontFamily") private var fontFamily: FontFamily = .serif
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteAlert = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section("Account Data") {
                    Button("Delete Account Data") {
                        showDeleteAlert = true
                    }
                    .foregroundColor(.red)
                    .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
                    .alert("Delete Account Data", isPresented: $showDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            deleteAccountData(modelContext: modelContext)
                            showDeleteConfirmation = true
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(
                            "This will permanently delete all your account data. This action cannot be undone."
                        )
                    }
                    .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
                    .alert("Data deleted successfully", isPresented: $showDeleteConfirmation) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Your account data has been deleted successfully.")
                    }
                }
            }
            .navigationTitle("Account Settings")
            .font(.system(size: 16, weight: .regular, design: fontFamily.fontDesign))
        }
    }

    //placed inside view becdause SwiftData does not play nice with MVVM architecture
    func deleteAccountData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Entry.self)
        } catch {
            print("Failed to delete account data: \(error.localizedDescription)")
            return
        }

        print("Account data deleted successfully.")
    }

}
