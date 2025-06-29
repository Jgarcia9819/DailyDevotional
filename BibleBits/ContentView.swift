//
//  ContentView.swift
//  BibleBits
//
//  Created by Joshua Garcia on 6/1/25.
//

import SwiftData
import SwiftUI
import UIKit

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @ObservedObject var bibleService = BibleService.shared

  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: UIFont(
        descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
          .withDesign(.serif)!, size: 30),
      .foregroundColor: UIColor.label,
    ]

    UINavigationBar.appearance().titleTextAttributes = [
      .font: UIFont(
        descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
          .withDesign(.serif)!, size: 17),  // Smaller size for collapsed state
      .foregroundColor: UIColor.label,
    ]
  }

  var body: some View {
    HomeView()
      .task {
        do {
          bibleService.loading = true
          defer { bibleService.loading = false }
          let bibleService = BibleService.shared
          let homeViewModel = HomeViewModel.shared

          try await bibleService.getDevotionals()
          await homeViewModel.fetchTodayDevotional()
          await homeViewModel.fetchBibleData()
          await homeViewModel.fetchRandomDevotional()
          await homeViewModel.fetchRandomBibleData()
          await homeViewModel.fetchBookInfo()
        } catch {
          print("Error fetching devotionals: \(error.localizedDescription)")
        }
      }
  }

}
