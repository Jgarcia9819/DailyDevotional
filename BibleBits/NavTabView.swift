import SwiftData
import SwiftUI
import UIKit

struct NavTabView: View {
  @State private var selectedTab: Int = 0
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {

    #if os(iOS)
      if #available(iOS 26.0, *) {
        TabView(selection: $selectedTab) {
          Tab("Read", systemImage: "book", value: 0) {
            HomeView()
          }
          Tab("Archive", systemImage: "archivebox", value: 1) {
            ArchiveView()
          }
          Tab("Settings", systemImage: "gear", value: 2) {
            SettingsView()
          }
        }
        .tint(colorScheme == .dark ? .white : .black)
        .tabBarMinimizeBehavior(.onScrollDown)
        .onAppear {
          #if os(iOS)
            if #available(iOS 18.0, *) {
              if colorScheme == .light {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor.white
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
              }
            }
          #endif
        }
      } else {
        TabView(selection: $selectedTab) {
          Tab("Read", systemImage: "book", value: 0) {
            HomeView()
          }
          Tab("Archive", systemImage: "archivebox", value: 1) {
            ArchiveView()
          }
          Tab("Settings", systemImage: "gear", value: 2) {
            SettingsView()
          }
        }
        .tint(colorScheme == .dark ? .white : .black)
        .onAppear {
          #if os(iOS)
            if #available(iOS 18.0, *) {
              if colorScheme == .light {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor.white
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
              }
            }
          #endif
        }
      }
    #endif
  }
}
