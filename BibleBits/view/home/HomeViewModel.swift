import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
  static let shared = HomeViewModel()
  @Published var todayDevotional: Devotional?
  @Published var randomDevotional: Devotional?
  @Published var bibleData: [BibleData] = []
  @Published var randomBibleData: [BibleData] = []
  @Published var entireRandomBibleData: [BibleData] = []
  @Published var entryText: String = ""
  @Published var saved: Bool = false
  @Published var showingFontEditSheet: Bool = false
  @Published var showingTextEditor: Bool = false
  @Published var isPassageSaved: Bool = false
  @Published var savedPassage: Saved?
  @Published var showingEntireChapter: Bool = false
  @Published var showingEntrySheet: Bool = false
  @Published var isRefreshing: Bool = false

  func fetchTodayDevotional() async {
    let bibleService = BibleService.shared
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let today = dateFormatter.string(from: Date())

    let devotional = bibleService.devotionals.first { devotional in

      return devotional.date == today
    }

    await MainActor.run {
      self.todayDevotional = devotional
    }
  }

  func fetchBibleData() async {
    let bibleService = BibleService.shared

    do {
      let data = try await bibleService.getBibleData(
        book: todayDevotional?.abbreviation ?? "",
        chapter: todayDevotional?.chapter ?? 0
      )
      let filtered = data.filter { verse in
        guard let start = todayDevotional?.start, let end = todayDevotional?.end else {
          return false
        }
        return verse.verse_start >= start && verse.verse_start <= end
      }
      await MainActor.run {
        self.bibleData = filtered
      }
    } catch {
      print("Error fetching Bible data: \(error)")
    }
  }

  func fetchRandomDevotional() async {
    let bibleService = BibleService.shared

    guard !bibleService.devotionals.isEmpty else {
      return
    }

    await MainActor.run {
      self.randomDevotional = bibleService.getRandomDevotional()
    }
  }

  func fetchRandomBibleData() async {
    let bibleService = BibleService.shared

    guard let randomDevotional = randomDevotional else {
      return
    }

    do {
      let data = try await bibleService.getBibleData(
        book: randomDevotional.abbreviation,
        chapter: randomDevotional.chapter
      )
      let filtered = data.filter { verse in
        let start = randomDevotional.start
        let end = randomDevotional.end
        return verse.verse_start >= start && verse.verse_start <= end
      }
      await MainActor.run {
        self.randomBibleData = filtered
        self.entireRandomBibleData = data
      }
    } catch {
      print("Error fetching Bible data: \(error)")
    }
  }

}
