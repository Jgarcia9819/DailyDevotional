import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                Section("Devotional") {
                    Text("Devotional content here")
                        .font(.subheadline)
                }
                Section("Reflection") {
                    TextField(">", text: .constant(""))
                }
                Section("Prayer") {
                    Text("Prayer content here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
