import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    Text("App Version: 1.0.0")
                        .font(.subheadline)
                    Text("Privacy Policy")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                Section("Account") {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
