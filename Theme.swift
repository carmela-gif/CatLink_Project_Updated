//
//  Theme.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

enum Theme {
    static let background = Color(red: 255/255, green: 244/255, blue: 212/255)
    static let accentYellow = Color(red: 255/255, green: 199/255, blue: 44/255)
    static let accentPurple = Color(red: 115/255, green: 86/255, blue: 241/255)
    static let cardBackground = Color.white.opacity(0.9)

    static func statusColor(_ status: String) -> Color {
        switch status {
        case "Needs Assistance": return accentYellow
        case "Under Observation": return Color.blue.opacity(0.3)
        case "Rescued": return accentPurple.opacity(0.3)
        case "Adopted": return Color.green.opacity(0.3)
        case "Resolved": return Color.gray.opacity(0.3)
        default: return accentYellow.opacity(0.5)
        }
    }
}

struct RoundedField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func roundedField() -> some View {
        modifier(RoundedField())
    }
}
