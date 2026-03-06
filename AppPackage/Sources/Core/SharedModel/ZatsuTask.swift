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

  public init(id: ID, name: String) {
    self.id = id
    self.name = name
  }
}

extension ZatsuTask {
  public static func sample(_ name: String) -> Self {
    Self(id: "id_\(name)", name: name)
  }
}
