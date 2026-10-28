//
//  CareReminder.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

enum ReminderTag: String, CaseIterable {
    case feeding, medication, vet, grooming

    var title: String {
        switch self {
        case .feeding: return "Feeding"
        case .medication: return "Medication"
        case .vet: return "Vet"
        case .grooming: return "Grooming"
        }
    }

    var icon: String {
        switch self {
        case .feeding: return "fork.knife"
        case .medication: return "pills.fill"
        case .vet: return "cross.case.fill"
        case .grooming: return "scissors"
        }
    }

    var color: Color {
        switch self {
        case .feeding: return Theme.accentYellow
        case .medication: return .blue
        case .vet: return Theme.accentPurple
        case .grooming: return .gray
        }
    }
}

struct CareReminder: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var date: String
    var tag: ReminderTag = .feeding
    var isCompleted: Bool = false
}
