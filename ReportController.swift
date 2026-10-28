//
//  ReportController.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import Foundation
internal import Combine

@MainActor
final class ReportController: ObservableObject {
    static let statuses = ["Needs Assistance", "Under Observation", "Rescued", "Adopted", "Resolved"]

    @Published var reports: [StrayReport] = [
        StrayReport(
            description: "Orange tabby, medium size, friendly",
            location: "Maple Street Park",
            date: "September 3, 2026",
            condition: "Injured — left front paw",
            additionalInformation: "Found near the playground entrance.",
            status: "Needs Assistance",
            reporterName: "Sarah Johnson"
        )
    ]

    func addReport(_ report: StrayReport) {
        reports.insert(report, at: 0)
    }

    func count(for status: String) -> Int {
        reports.filter { $0.status == status }.count
    }

    func updateStatus(of report: StrayReport, to newStatus: String) {
        if let index = reports.firstIndex(where: { $0.id == report.id }) {
            reports[index].status = newStatus
        }
    }
}
