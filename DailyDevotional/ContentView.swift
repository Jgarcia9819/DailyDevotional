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

    var body: some View {
        NavTabView()
            .task {
                do {
                    let bibleService = BibleService.shared
                    let homeViewModel = HomeViewModel.shared

                    try await bibleService.getDevotionals()
                    try await homeViewModel.fetchTodayDevotional()
                    try await homeViewModel.fetchBibleData()
                } catch {
                    print("Error fetching devotionals: \(error.localizedDescription)")
                }
            }
    }

}
