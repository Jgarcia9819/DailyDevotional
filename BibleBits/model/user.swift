import Foundation
import SwiftData

@Model
class User {
  var id: String?
  var name: String?
  var email: String?
  var createdAt: Date?

  init(id: String?, name: String?, email: String?) {
    self.id = id
    self.name = name
    self.email = email
    self.createdAt = Date.now
  }
}
