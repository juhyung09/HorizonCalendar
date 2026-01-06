// Created by OpenAI

import Foundation

enum CalendarLocalization {

  static func monthName(for month: Int, calendar: Calendar) -> String {
    guard month >= 1, month <= monthKeys.count else {
      return "\(month)"
    }

    let key = monthKeys[month - 1]
    return localizedString(forKey: key, calendar: calendar)
  }

  static func weekdaySymbol(for weekdayIndex: Int, calendar: Calendar) -> String {
    guard weekdayIndex >= 0, weekdayIndex < weekdayKeys.count else {
      return ""
    }

    let key = weekdayKeys[weekdayIndex]
    return localizedString(forKey: key, calendar: calendar)
  }

  // MARK: Private

  private static let monthKeys = [
    "calendar.month.january",
    "calendar.month.february",
    "calendar.month.march",
    "calendar.month.april",
    "calendar.month.may",
    "calendar.month.june",
    "calendar.month.july",
    "calendar.month.august",
    "calendar.month.september",
    "calendar.month.october",
    "calendar.month.november",
    "calendar.month.december",
  ]

  private static let weekdayKeys = [
    "calendar.weekday.sunday",
    "calendar.weekday.monday",
    "calendar.weekday.tuesday",
    "calendar.weekday.wednesday",
    "calendar.weekday.thursday",
    "calendar.weekday.friday",
    "calendar.weekday.saturday",
  ]

  private static func localizedString(forKey key: String, calendar: Calendar) -> String {
    let bundle = bundle(for: calendar)
    return bundle.localizedString(forKey: key, value: nil, table: "Localizable")
  }

  private static func bundle(for calendar: Calendar) -> Bundle {
    let languageCode = calendar.locale?.languageCode ?? Locale.current.languageCode

    guard
      let languageCode,
      let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"),
      let bundle = Bundle(path: path)
    else {
      return Bundle.module
    }

    return bundle
  }

}
