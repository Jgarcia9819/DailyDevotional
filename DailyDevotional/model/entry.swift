import Foundation
import SwiftData

@Model
final class Entry: Identifiable {
    var id: UUID = UUID()
    var devoID: Int?
    var createdAt: Date = Date()
    var content: String = ""
    var saved: Bool = false

    init(id: UUID, devoID: Int?, createdAt: Date = Date(), content: String, saved: Bool = false) {
        self.saved = saved
        self.devoID = devoID
        self.createdAt = createdAt
        self.content = content
    }
}
