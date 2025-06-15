import Foundation

class EditViewModel: ObservableObject {
    static let shared = EditViewModel()
    @Published var isSaved: Bool = false
    @Published var editedBibleData: [BibleData] = []
    @Published var editedDevotional: Devotional?

    func getEditedBibleData(entry: Entry) async {
        let bibleService = BibleService.shared

        guard let devotional = bibleService.devotionals.first(where: { $0.id == entry.devoID })
        else {
            return print("Devotional not found for ID: \(String(describing: entry.devoID))")

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
