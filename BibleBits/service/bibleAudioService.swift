import AVFoundation
import Foundation

struct BibleAudioTimings: Codable {
  let book_id: String
  let chapter: Int
  let verse_start: Int
  let verse_start_alt: Int
  let timestamp: [Int]
}

class BibleAudioService: ObservableObject {
  let bibleAudioTimingsURL =
    "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/audio-timings"
  let bibleAudioURL = "https://bibleapi-ashy.vercel.app/api/proxy/bible/audio"
  @Published var audioTimings: [BibleAudioTimings] = []
  @Published var player: AVPlayer?
  @Published var isAudioPlaying: Bool = false
  @Published var isAudioPaused: Bool = false
  @Published var isAudioLoading: Bool = false

  static let shared = BibleAudioService()

  func getAudioTimings(book: String, chapter: Int) async throws -> [BibleAudioTimings] {
    let urlString = "\(bibleAudioTimingsURL)/\(book)/\(chapter)"
    print("Requesting URL: \(urlString)")

    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    do {
      // Print the raw JSON for debugging
      if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON: \(jsonString)")
      }

      let decoder = JSONDecoder()
      // Based on the example response, we need to decode {"data": [...]}
      let response = try decoder.decode([String: [BibleAudioTimings]].self, from: data)

      // Get the array from the "data" key
      if let timings = response["data"] {
        return timings
      }
      return []
    } catch {
      print("Decoding error: \(error)")
      throw error
    }
  }

  func setupAudioPlayer(book: String, chapter: Int) async {
    do {
      isAudioLoading = true
      let audioURL = "\(bibleAudioURL)?book=\(book)&chapter=\(chapter)&version=ENGESV"
      guard let url = URL(string: audioURL) else {
        throw URLError(.badURL)
      }
      let playerItem = AVPlayerItem(url: url)
      await MainActor.run {
        self.player = AVPlayer(playerItem: playerItem)
        player?.play()
      }

      isAudioLoading = false
    } catch {
      print("Error setting up audio player: \(error)")
    }
  }
  func pauseAudio() {
    player?.pause()
    isAudioPlaying = false
    isAudioPaused = true
  }
  func playAudio() {
    player?.play()
    isAudioPlaying = true
    isAudioPaused = false
  }

}
