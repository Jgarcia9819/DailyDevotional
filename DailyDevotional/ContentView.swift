//
//  ContentView.swift
//  DailyDevotional
//
//  Created by Joshua Garcia on 6/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            NavTabView()
        }
        
    }

}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer(for: Schema([])))
}
