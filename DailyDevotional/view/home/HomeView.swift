import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Daily Devotional")
                    .font(.largeTitle)
                    .padding()
                
                // Add more content here as needed
            }
            .navigationTitle("Home")
        }
    }
}

struct MockData{
    var title = "devotional1"
    var content = "This is a sample devotional content."
    var date = Date()
    var book = "Genesis"
    var chapter = 1
    var range = "1:1-5"
    var version = "ESV"
}