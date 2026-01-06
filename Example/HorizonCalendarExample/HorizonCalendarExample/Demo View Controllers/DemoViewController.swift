// Created by Bryan Keller on 6/18/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

import HorizonCalendar
import UIKit

// MARK: - DemoViewController

protocol DemoViewController: UIViewController {

  init(monthsLayout: MonthsLayout)

  var calendar: Calendar { get }
  var monthsLayout: MonthsLayout { get }

}

// MARK: - CalendarLanguage

enum CalendarLanguage: Int, CaseIterable {

  case korean
  case english
  case vietnamese

  var title: String {
    switch self {
    case .korean:
      return "한국어"
    case .english:
      return "English"
    case .vietnamese:
      return "Tiếng Việt"
    }
  }

  var localeIdentifier: String {
    switch self {
    case .korean:
      return "ko"
    case .english:
      return "en"
    case .vietnamese:
      return "vi"
    }
  }

  static func preferredLanguage(for locale: Locale) -> CalendarLanguage {
    guard let languageCode = locale.languageCode else {
      return .english
    }

    switch languageCode {
    case "ko":
      return .korean
    case "vi":
      return .vietnamese
    default:
      return .english
    }
  }

}

// MARK: - BaseDemoViewController

class BaseDemoViewController: UIViewController, DemoViewController {

  // MARK: Lifecycle

  required init(monthsLayout: MonthsLayout) {
    self.monthsLayout = monthsLayout
    calendar = Calendar.current
    selectedLanguage = CalendarLanguage.preferredLanguage(
      for: calendar.locale ?? Locale.current
    )
    calendar.locale = Locale(identifier: selectedLanguage.localeIdentifier)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let monthsLayout: MonthsLayout

  lazy var calendarView = CalendarView(initialContent: makeContent())
  var calendar: Calendar
  var dayDateFormatter = DateFormatter()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    configureDayDateFormatter()

    languageControl.selectedSegmentIndex = selectedLanguage.rawValue

    let stackView = UIStackView(arrangedSubviews: [languageControl, calendarView])
    stackView.axis = .vertical
    stackView.spacing = 12
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)

    calendarView.translatesAutoresizingMaskIntoConstraints = false
    switch monthsLayout {
    case .vertical:
      NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
        calendarView.widthAnchor.constraint(equalToConstant: 375).prioritize(at: .defaultLow),
      ])

    case .horizontal:
      NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
        calendarView.widthAnchor.constraint(equalToConstant: 375).prioritize(at: .defaultLow),
      ])
    }
  }

  func makeContent() -> CalendarViewContent {
    fatalError("Must be implemented by a subclass.")
  }

  func updateAdditionalFormatters() {}

  // MARK: Private

  private lazy var languageControl: UISegmentedControl = {
    let control = UISegmentedControl(items: CalendarLanguage.allCases.map(\.title))
    control.addTarget(self, action: #selector(languageDidChange), for: .valueChanged)
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  private var selectedLanguage: CalendarLanguage

  private func configureDayDateFormatter() {
    dayDateFormatter.calendar = calendar
    dayDateFormatter.locale = calendar.locale
    dayDateFormatter.dateFormat = DateFormatter.dateFormat(
      fromTemplate: "EEEE, MMM d, yyyy",
      options: 0,
      locale: calendar.locale ?? Locale.current
    )
  }

  @objc private func languageDidChange() {
    guard let language = CalendarLanguage(rawValue: languageControl.selectedSegmentIndex) else {
      return
    }

    selectedLanguage = language
    calendar.locale = Locale(identifier: language.localeIdentifier)
    configureDayDateFormatter()
    updateAdditionalFormatters()
    calendarView.setContent(makeContent())
  }

}

// MARK: NSLayoutConstraint + Priority Helper

extension NSLayoutConstraint {

  fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }

}
