import Foundation

struct Devotional: Codable {
    let id: Int
    let description: String
    let book: String
    let chapter: Int
    let version: String
    let start: Int
    let end: Int
    let date: String
}

class BibleService: ObservableObject {
    let devotionalURL = "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/devotions"
    @Published var devotionals: [Devotional] = []

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
}
