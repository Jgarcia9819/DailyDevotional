import Foundation
import SwiftData

@Model
final class Entry {
    var devoID: String
    var createdAt: Date
    var content: String

    init(devoID: String, createdAt: Date = Date(), content: String) {
        self.devoID = devoID
        self.createdAt = createdAt
        self.content = content
    }
}
