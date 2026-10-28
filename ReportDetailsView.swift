//
//  ReportDetailsView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct ReportDetailsView: View {
    @EnvironmentObject var reportController: ReportController
    @EnvironmentObject var authController: AuthController

    let report: StrayReport

    private var current: StrayReport {
        reportController.reports.first(where: { $0.id == report.id }) ?? report
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenHeader(title: "Report Details")
                        .padding(.horizontal)

                    photo

                    HStack {
                        Text("Current Status")
                            .font(.headline)
                        Spacer()
                        StatusChip(status: current.status, large: true)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        InfoCard(label: "Description", value: current.description)
                        InfoCard(label: "Location", value: current.location)
                        InfoCard(label: "Date Reported", value: current.date)
                        InfoCard(label: "Condition", value: current.condition)
                        if !current.additionalInformation.isEmpty {
                            InfoCard(label: "Additional Information", value: current.additionalInformation)
                        }
                        InfoCard(label: "Reporter",
                                 value: current.reporterName.isEmpty ? "Anonymous" : current.reporterName)
                    }
                    .padding(.horizontal)

                    if authController.isAdmin {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Update Status")
                                .font(.headline)

                            ForEach(ReportController.statuses, id: \.self) { status in
                                Button {
                                    reportController.updateStatus(of: report, to: status)
                                } label: {
                                    HStack {
                                        Text(status)
                                            .font(.subheadline.weight(.semibold))
                                        Spacer()
                                        if status == current.status {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(status == current.status ? Theme.statusColor(status) : Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Text("Status Timeline")
                        .font(.headline)
                        .padding(.horizontal)

                    TimelineCard(steps: current.timeline, accent: Theme.accentYellow)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .padding(.top, 8)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var photo: some View {
        Group {
            if let data = current.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    VStack(spacing: 6) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                        Text("No photo provided")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

struct TimelineStep: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let isCurrent: Bool
}

extension StrayReport {
    var timeline: [TimelineStep] {
        let stages = ReportController.statuses
        let currentIndex = stages.firstIndex(of: status) ?? 0

        return stages.enumerated().map { index, stage in
            let subtitle: String
            if index == currentIndex {
                subtitle = index == 0 ? "Reported \(date)" : "Current stage"
            } else if index == currentIndex + 1 {
                subtitle = "Pending dispatch"
            } else if index < currentIndex {
                subtitle = "Completed"
            } else {
                subtitle = "Upcoming"
            }

            return TimelineStep(
                title: stage,
                subtitle: subtitle,
                isCompleted: index < currentIndex,
                isCurrent: index == currentIndex
            )
        }
    }
}

private struct InfoCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body.weight(.semibold))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct TimelineCard: View {
    let steps: [TimelineStep]
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 14) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(step.isCurrent ? accent : (step.isCompleted ? .black : Color.gray.opacity(0.3)))
                            .frame(width: step.isCurrent ? 14 : 10, height: step.isCurrent ? 14 : 10)
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 2)
                                .frame(minHeight: 36)
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                            .font(.subheadline.weight(step.isCurrent ? .bold : .semibold))
                            .foregroundStyle(step.isCurrent || step.isCompleted ? .black : .secondary)
                        Text(step.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, index < steps.count - 1 ? 16 : 0)

                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        ReportDetailsView(
            report: StrayReport(
                description: "Orange tabby, medium size, friendly",
                location: "Maple Street Park",
                date: "September 3, 2026",
                condition: "Injured — left front paw",
                additionalInformation: "Found near the playground entrance.",
                status: "Needs Assistance",
                reporterName: "Sarah Johnson"
            )
        )
    }
    .environmentObject(ReportController())
    .environmentObject(AuthController())
}
