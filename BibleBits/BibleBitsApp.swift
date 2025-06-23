//
//  BibleBitsApp.swift
//  BibleBits
//
//  Created by Joshua Garcia on 6/1/25.
//

import SwiftData
import SwiftUI
import UIKit

@main
struct BibleBitsApp: App {
  @Environment(\.colorScheme) private var colorScheme
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([Entry.self, Saved.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}
