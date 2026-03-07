import ID

public struct ZatsuTask: Equatable, Hashable, Sendable, Identifiable {
  public struct ID: StringIDProtocol {
    public let rawValue: String

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }

  public let id: ID
  public let name: String
  public let isDone: Bool

  public init(id: ID, name: String, isDone: Bool) {
    self.id = id
    self.name = name
    self.isDone = isDone
  }
}

// MARK: - Mock

extension ZatsuTask {
  public static func mock(_ name: String) -> Self {
    Self(id: "id_\(name)", name: name, isDone: false)
  }
}
