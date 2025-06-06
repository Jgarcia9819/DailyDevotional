import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    static let shared = HomeViewModel()
    @Published var todayDevotional: Devotional?
    @Published var bibleData: [BibleData] = []
    @Published var entryText: String = ""

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

}
