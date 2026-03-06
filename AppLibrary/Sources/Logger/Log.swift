import Foundation
import OSLog

private let subsystem = Bundle.main.bundleIdentifier ?? ""

public enum Log {
  public static let `default` = Logger(subsystem: subsystem, category: LogCategory.default.rawValue)
}

public enum LogCategory: String {
  case `default`
}
