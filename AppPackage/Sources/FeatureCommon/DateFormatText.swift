import Foundation

public enum DateFormatText {
  public static func yyyyMdHHmm(from date: Date) -> String {
    makeLocalizedString(from: date, format: "yyyy-MM-dd HH:mm")
  }
}

extension DateFormatText {
  private static func makeLocalizedString(
    from date: Date,
    format: String,
    locale: Locale = Locale.current,
    timeZone: TimeZone = TimeZone.current
  ) -> String {
    makeLocalizedFormat(format: format, locale: locale, timeZone: timeZone).string(from: date)
  }

  private static func makeLocalizedFormat(
    format: String,
    locale: Locale = Locale.current,
    timeZone: TimeZone = TimeZone.current
  ) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = locale
    formatter.timeZone = timeZone
    formatter.dateFormat = format
    return formatter
  }
}
