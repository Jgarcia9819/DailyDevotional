import Foundation
import SwiftData

@Model
final class Saved: Identifiable {
    var id: UUID = UUID()
    var book: String = ""
    var chapter: Int = 0
    var start: Int = 0
    var end: Int = 0

    init(id: UUID, book: String = "", chapter: Int = 0, start: Int = 0, end: Int = 0){
        self.book = book
        self.chapter = chapter
        self.start = start
        self.end = end
    }


}