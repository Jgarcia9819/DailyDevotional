import Foundation
import SwiftData

@Model
final class Entry: Identifiable {
    var id: UUID = UUID()
    var devoID: Int?
    var createdAt: Date = Date()
    var content: String = ""
    var saved: Bool = false
    var book: String = ""
    var chapter: Int = 0
    var start: Int = 0
    var end: Int = 0

    init(
        id: UUID, devoID: Int?, createdAt: Date = Date(), content: String, saved: Bool = false,
        book: String = "", chapter: Int = 0, start: Int = 0, end: Int = 0
    ) {
        self.saved = saved
        self.devoID = devoID
        self.createdAt = createdAt
        self.content = content
        self.book = book
        self.chapter = chapter
        self.start = start
        self.end = end
    }
}
