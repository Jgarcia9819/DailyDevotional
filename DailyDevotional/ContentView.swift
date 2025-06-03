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

    }

}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer(for: Schema([])))
}
