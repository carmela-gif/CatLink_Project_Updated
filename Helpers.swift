//
//  Helpers.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI
import UserNotifications

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

enum Validator {
    static func isValidEmail(_ email: String) -> Bool {
        email.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) != nil
    }

    static func isValidUsername(_ username: String) -> Bool {
        username.count >= 3 && !username.contains(" ")
    }

    static func isValidPassword(_ password: String) -> Bool {
        password.count >= 6
    }
}

enum Formatters {
    private static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter
    }

    static func reportDate(_ date: Date) -> String {
        formatter("MMMM d, yyyy").string(from: date)
    }

    static func reminderDate(_ date: Date) -> String {
        let time = formatter("h:mm a").string(from: date)
        if Calendar.current.isDateInToday(date) { return "Today, \(time)" }
        if Calendar.current.isDateInTomorrow(date) { return "Tomorrow, \(time)" }
        return "\(formatter("MMM d").string(from: date)), \(time)"
    }

    static func greeting(for date: Date = Date()) -> String {
        switch Calendar.current.component(.hour, from: date) {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
}

extension UIImage {
    func compressedData(maxDimension: CGFloat = 1200, quality: CGFloat = 0.7) -> Data? {
        let largest = max(size.width, size.height)
        guard largest > maxDimension else { return jpegData(compressionQuality: quality) }

        let scale = maxDimension / largest
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let resized = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: quality)
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}

enum NotificationScheduler {
    static let remindersKey = "notifyReminders"

    static func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    static func schedule(id: UUID, title: String, body: String, at date: Date) {
        let enabled = UserDefaults.standard.object(forKey: remindersKey) as? Bool ?? true
        guard enabled, date > Date() else { return }

        requestPermission { granted in
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let components = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute], from: date
            )
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            UNUserNotificationCenter.current().add(
                UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
            )
        }
    }

    static func cancel(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}
