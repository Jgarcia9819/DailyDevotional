import Foundation
import SwiftData

@Model
final class Saved: Identifiable {
    var id: UUID = UUID()
    var devoID: Int?
    var book: String = ""
    var chapter: Int = 0
    var start: Int = 0
    var end: Int = 0
    var createdAt: Date = Date()

    init(id: UUID, devoID: Int?,book: String = "", chapter: Int = 0, start: Int = 0, end: Int = 0, createdAt: Date = Date()){
        self.devoID = devoID
        self.book = book
        self.chapter = chapter
        self.start = start
        self.end = end
        self.createdAt = createdAt
    }


}