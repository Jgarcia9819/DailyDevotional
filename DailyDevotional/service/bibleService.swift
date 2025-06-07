import Foundation

struct Devotional: Codable {
    let id: Int
    let description: String
    let book: String
    let abbreviation: String
    let chapter: Int
    let version: String
    let start: Int
    let end: Int
    let date: String
}

struct BibleData: Codable, Identifiable {
    let book_id: String
    let book_name: String
    let book_name_alt: String
    let chapter: Int
    let chapter_alt: String
    let verse_start: Int
    let verse_start_alt: String
    let verse_end: Int
    let verse_end_alt: String
    let verse_text: String

    var id: String {
        return "\(book_id)-\(chapter)-\(verse_start)"
    }
}

struct BibleDataResponse: Codable {
    let data: [BibleData]
}

class BibleService: ObservableObject {
    let devotionalURL = "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/devotions"
    let bibleURL = "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/data/"
    @Published var devotionals: [Devotional] = []
    static let shared = BibleService()

    func getDevotionals() async throws {
        guard let url = URL(string: devotionalURL) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        do {
            let decoder = JSONDecoder()
            self.devotionals = try decoder.decode([Devotional].self, from: data)
            print("devotionals: \(self.devotionals)")

        } catch {
            throw error
        }
    }

    func getRandomDevotional() -> Devotional? {
        return devotionals.randomElement()
    }

    func getBibleData(book: String, chapter: Int) async throws -> [BibleData] {
        let urlString = "\(bibleURL)\(book)/\(chapter)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        do {
            let decoder = JSONDecoder()
            let bibleData = try decoder.decode(BibleDataResponse.self, from: data)
            print("bibleData: \(bibleData)")
            return bibleData.data

        } catch {
            throw error
        }
    }
}
