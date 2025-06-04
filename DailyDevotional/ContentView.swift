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
    @StateObject private var bibleService = BibleService()

    var body: some View {
        NavTabView(bibleService: bibleService)
            .task {
                do {
                    print("Fetching devotionals...")

                    try await bibleService.getDevotionals()
                } catch {
                    print("Error fetching devotionals: \(error.localizedDescription)")
                }
            }
    }

}
