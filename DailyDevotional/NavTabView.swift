import SwiftData
import SwiftUI

struct NavTabView: View {
    @State private var selectedTab: Int = 0
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bibleService: BibleService

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("", systemImage: "calendar", value: 0) {
                HomeView()
            }
            Tab("", systemImage: "list.bullet.rectangle.portrait.fill", value: 1) {
                ArchiveView(bibleService: bibleService)
            }
            Tab("", systemImage: "gear", value: 2) {
                SettingsView()
            }
        }
    }

}
