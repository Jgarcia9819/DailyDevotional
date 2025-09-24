import Foundation

struct Devotional: Codable {
  let id: Int
  let description: String
  let book: String
  let abbreviation: String
  let chapter: Int
  let version: String
  let start: Int?
  let end: Int?
  let date: String
  //let bookInfo: String
  //let chapterContext: String
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

struct BookInfo: Codable {
  let type: String
  let title: String
  let displaytitle: String
  let namespace: Namespace
  let pageid: Int
  let thumbnail: ImageInfo?
  let originalimage: ImageInfo?
  let lang: String
  let dir: String
  let revision: String
  let timestamp: String
  let description: String
  let extract: String
  let extract_html: String

  struct Namespace: Codable {
    let id: Int
    let text: String
  }

  struct ImageInfo: Codable {
    let source: String
    let width: Int
    let height: Int
  }
}

class BibleService: ObservableObject {
  let devotionalURL = "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/devotions"
  let bibleURL = "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/data/"
  let wikiURL = "https://en.wikipedia.org/api/rest_v1/page/summary/:"
  @Published var devotionals: [Devotional] = []
  @Published var loading: Bool = false
  static let shared = BibleService()

  // Book abbreviation to descriptor mapping
  static let bookMapping: [String: String] = [
    "GEN": "Book_of_Genesis",
    "EXO": "Book_of_Exodus",
    "LEV": "Book_of_Leviticus",
    "NUM": "Book_of_Numbers",
    "DEU": "Book_of_Deuteronomy",
    "JOS": "Book_of_Joshua",
    "JDG": "Book_of_Judges",
    "RUT": "Book_of_Ruth",
    "1SA": "Books_of_Samuel",
    "2SA": "Books_of_Samuel",
    "1KI": "Books_of_Kings",
    "2KI": "Books_of_Kings",
    "1CH": "Books_of_Chronicles",
    "2CH": "Books_of_Chronicles",
    "EZR": "Book_of_Ezra",
    "NEH": "Book_of_Nehemiah",
    "EST": "Book_of_Esther",
    "JOB": "Book_of_Job",
    "PSA": "Book_of_Psalms",
    "PRO": "Book_of_Proverbs",
    "ECC": "Book_of_Ecclesiastes",
    "SNG": "Book_of_Song_of_Songs",
    "ISA": "Book_of_Isaiah",
    "JER": "Book_of_Jeremiah",
    "LAM": "Book_of_Lamentations",
    "EZK": "Book_of_Ezekiel",
    "DAN": "Book_of_Daniel",
    "HOS": "Book_of_Hosea",
    "JOL": "Book_of_Joel",
    "AMO": "Book_of_Amos",
    "OBA": "Book_of_Obadiah",
    "JON": "Book_of_Jonah",
    "MIC": "Book_of_Micah",
    "NAH": "Book_of_Nahum",
    "HAB": "Book_of_Habakkuk",
    "ZEP": "Book_of_Zephaniah",
    "HAG": "Book_of_Haggai",
    "ZEC": "Book_of_Zechariah",
    "MAL": "Book_of_Malachi",
    // New Testament
    "MAT": "Gospel_of_Matthew",
    "MRK": "Gospel_of_Mark",
    "LUK": "Gospel_of_Luke",
    "JHN": "Gospel_of_John",
    "ACT": "Acts_of_the_Apostles",
    "ROM": "Epistle_to_the_Romans",
    "1CO": "First_Epistle_to_the_Corinthians",
    "2CO": "Second_Epistle_to_the_Corinthians",
    "GAL": "Epistle_to_the_Galatians",
    "EPH": "Epistle_to_the_Ephesians",
    "PHP": "Epistle_to_the_Philippians",
    "COL": "Epistle_to_the_Colossians",
    "1TH": "First_Epistle_to_the_Thessalonians",
    "2TH": "Second_Epistle_to_the_Thessalonians",
    "1TI": "First_Epistle_to_Timothy",
    "2TI": "Second_Epistle_to_Timothy",
    "TIT": "Epistle_to_Titus",
    "PHM": "Epistle_to_Philemon",
    "HEB": "Epistle_to_the_Hebrews",
    "JAS": "Epistle_of_James",
    "1PE": "First_Epistle_of_Peter",
    "2PE": "Second_Epistle_of_Peter",
    "1JN": "First_Epistle_of_John",
    "2JN": "Second_Epistle_of_John",
    "3JN": "Third_Epistle_of_John",
    "JUD": "Epistle_of_Jude",
    "REV": "Book_of_Revelation",
  ]

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
      let devotionals = try decoder.decode([Devotional].self, from: data)
      await MainActor.run {
        self.devotionals = devotionals
      }
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
      return bibleData.data

    } catch {
      throw error
    }
  }
/*
  func getBookInfo(book: String) async throws -> BookInfo {
    let book = BibleService.bookMapping[book] ?? book
    let urlString = "\(wikiURL)\(book)"
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    do {
      let decoder = JSONDecoder()
      let bookInfo = try decoder.decode(BookInfo.self, from: data)
      return bookInfo
    } catch {
      throw error
    }
  }
*/
}
