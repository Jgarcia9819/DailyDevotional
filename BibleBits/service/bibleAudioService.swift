import AVFoundation
import Foundation

struct BibleAudioTimings: Codable {
  let book: String
  let chapter: String
  let verse_start: String
  let verse_start_alt: String
  let timestamp: Double
}

class BibleAudioService: ObservableObject {
  let bibleAudioTimingsURL =
    "https://2801hae26l.execute-api.us-west-2.amazonaws.com/dev/api/audio-timings"
  let bibleAudioURL = "https://bible-audio-api.jgarcia9819.workers.dev"
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

  func setupAudioPlayer(book: String, chapter: Int, verseStart: Int = 1, verseEnd: Int? = nil) async
  {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      await MainActor.run {
        self.isAudioLoading = true
        self.isAudioPaused = false
      }

      // Get audio timings
      let timings = try await getAudioTimings(book: book, chapter: chapter)

      // Find start timestamp
      let startTimestamp =
        timings.first(where: { Int($0.verse_start) == verseStart })?.timestamp ?? 0

      // Find end timestamp
      let endTimestamp: Double?
      if let verseEnd = verseEnd, verseEnd > verseStart {
        // Multi-verse range: find the start of the verse after the end verse
        endTimestamp = timings.first(where: { Int($0.verse_start) == verseEnd + 1 })?.timestamp
      } else {
        // Single verse: find the start of the next verse after the start verse
        endTimestamp = timings.first(where: { Int($0.verse_start) == verseStart + 1 })?.timestamp
      }

      // Setup audio player
      let audioURL = "\(bibleAudioURL)?book=\(book)&chapter=\(chapter)&version=ENGESV"
      guard let url = URL(string: audioURL) else {
        throw URLError(.badURL)
      }

      let playerItem = AVPlayerItem(url: url)
      await MainActor.run {
        self.player = AVPlayer(playerItem: playerItem)

        // Set start time
        let startTime = CMTime(seconds: startTimestamp, preferredTimescale: 1000)
        player?.seek(to: startTime)

        player?.play()
        self.isAudioPlaying = true
        self.isAudioPaused = false

        // If end timestamp exists, set a timer to stop playback
        if let endTimestamp = endTimestamp {
          let duration = endTimestamp - startTimestamp
          DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            Task { @MainActor in
              self?.resetAudio()
            }
          }
        }

      }

      await MainActor.run { self.isAudioLoading = false }
    } catch {
      print("Error setting up audio player: \(error)")
      await MainActor.run {
        self.isAudioLoading = false
        self.isAudioPlaying = false
        self.isAudioPaused = false
      }
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

  func resetAudio() {
    player?.pause()
    player = nil
    isAudioPlaying = false
    isAudioPaused = false
    isAudioLoading = false
  }
}