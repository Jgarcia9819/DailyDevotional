import Foundation

class ReadViewModel: ObservableObject {
    static let shared = ReadViewModel()
    @Published var isSaved: Bool = false
    @Published var editedBibleData: [BibleData] = []
    @Published var editedDevotional: Devotional?

    func getEditedBibleData(saved: Saved) async {
        let bibleService = BibleService.shared

        guard let devotional = bibleService.devotionals.first(where: { $0.id == saved.devoID })
        else {
            return print("Devotional not found for ID: \(String(describing: saved.devoID))")

        }
        await MainActor.run {
            self.editedDevotional = devotional
        }

        do {
            let data = try await bibleService.getBibleData(
                book: devotional.abbreviation,
                chapter: devotional.chapter
            )
            let filtered = data.filter { verse in
                guard let start = editedDevotional?.start, let end = editedDevotional?.end else {
                    return false
                }
                return verse.verse_start >= start && verse.verse_start <= end
            }
            await MainActor.run {
                self.editedBibleData = filtered
            }
        } catch {
            print("Error fetching Bible data: \(error)")
        }
    }

}
