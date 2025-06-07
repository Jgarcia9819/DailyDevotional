//
//  ContentView.swift
//  DailyDevotional
//
//  Created by Joshua Garcia on 6/1/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bibleService = BibleService.shared

    var body: some View {
        NavTabView()
            .task {
                do {
                    bibleService.loading = true
                    defer { bibleService.loading = false }
                    let bibleService = BibleService.shared
                    let homeViewModel = HomeViewModel.shared

                    try await bibleService.getDevotionals()
                    try await homeViewModel.fetchTodayDevotional()
                    try await homeViewModel.fetchBibleData()
                    try await homeViewModel.fetchRandomDevotional()
                    try await homeViewModel.fetchRandomBibleData()
                } catch {
                    print("Error fetching devotionals: \(error.localizedDescription)")
                }
            }
    }

}
