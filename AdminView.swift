//
//  AdminView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var reportController: ReportController
    @EnvironmentObject var authController: AuthController

    @State private var selectedFilter = "All"
    @State private var showLogoutConfirmation = false

    private var filters: [String] { ["All"] + ReportController.statuses }

    private var filteredReports: [StrayReport] {
        selectedFilter == "All"
            ? reportController.reports
            : reportController.reports.filter { $0.status == selectedFilter }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Admin").font(.title3.weight(.bold))
                                Text("Rescue Management").font(.title.bold())
                            }
                            Spacer()
                            Button {
                                showLogoutConfirmation = true
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Log out")
                        }

                        HStack(spacing: 12) {
                            SummaryCard(title: "Needs Help",
                                        value: reportController.count(for: "Needs Assistance"),
                                        tint: Theme.accentYellow.opacity(0.4))
                            SummaryCard(title: "Rescued",
                                        value: reportController.count(for: "Rescued"),
                                        tint: Theme.accentPurple.opacity(0.18))
                            SummaryCard(title: "Total",
                                        value: reportController.reports.count,
                                        tint: Color.white)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(filters, id: \.self) { filter in
                                    Button {
                                        selectedFilter = filter
                                    } label: {
                                        Text(filter)
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(selectedFilter == filter ? Theme.accentYellow : Color.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }

                        Text("Reports").font(.headline)

                        if filteredReports.isEmpty {
                            Text("No reports in this status.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(filteredReports) { report in
                                    AdminReportCard(report: report)
                                }
                            }
                        }
                    }
                    .padding(24)
                    .foregroundStyle(.black)
                }
            }
            .navigationBarHidden(true)
            .confirmationDialog("Log out of CatLink?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                Button("Log Out", role: .destructive) {
                    authController.logout()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

private struct SummaryCard: View {
    let title: String
    let value: Int
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value)").font(.title.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(tint)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct AdminReportCard: View {
    @EnvironmentObject var reportController: ReportController
    let report: StrayReport

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink {
                ReportDetailsView(report: report)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(report.description)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.black)
                            .lineLimit(1)
                        Text("\(report.location) • \(report.date)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        Text(report.condition)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            Menu {
                ForEach(ReportController.statuses, id: \.self) { status in
                    Button {
                        reportController.updateStatus(of: report, to: status)
                    } label: {
                        if status == report.status {
                            Label(status, systemImage: "checkmark")
                        } else {
                            Text(status)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(report.status)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("Update")
                        .font(.caption.weight(.semibold))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Theme.statusColor(report.status))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    AdminView()
        .environmentObject(AuthController())
        .environmentObject(ReportController())
}
