//
//  DashboardView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var catController: CatController
    @EnvironmentObject var reminderController: ReminderController
    @EnvironmentObject var reportController: ReportController
    @Binding var selectedTab: AppTab

    private var firstName: String {
        authController.user.fullName.split(separator: " ").first.map(String.init) ?? "there"
    }

    private var catSummary: String {
        let cats = catController.cats
        if cats.isEmpty { return "Add your first cat to get started." }
        let names = cats.map(\.name).joined(separator: " & ")
        return "\(names) \(cats.count == 1 ? "is" : "are") doing great today!"
    }

    private var familySummary: String {
        let cats = catController.cats
        if cats.isEmpty { return "No cats yet" }
        return cats.map { "\($0.name) (\($0.age))" }.joined(separator: " • ")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dashboard")
                                .font(.title3.weight(.bold))
                            Text("\(Formatters.greeting()), \(firstName)")
                                .font(.title.bold())
                            Text(catSummary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Button {
                            selectedTab = .cats
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "pawprint.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Theme.accentPurple)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Your Cat Family").font(.headline)
                                    Text(familySummary)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }

                                Spacer()

                                Text("\(catController.cats.count) \(catController.cats.count == 1 ? "Cat" : "Cats")")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Theme.accentYellow.opacity(0.3))
                                    .clipShape(Capsule())
                            }
                            .padding()
                            .background(Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)

                        Text("Quick Actions").font(.headline)

                        Button {
                            selectedTab = .cats
                        } label: {
                            ActionCard(title: "My Cats",
                                       subtitle: "\(catController.cats.count) \(catController.cats.count == 1 ? "Cat" : "Cats")",
                                       icon: "cat.fill", tint: Theme.accentYellow.opacity(0.35))
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            ReportsView()
                        } label: {
                            ActionCard(title: "Reports",
                                       subtitle: "\(reportController.reports.count) \(reportController.reports.count == 1 ? "Report" : "Reports")",
                                       icon: "list.bullet.clipboard", tint: Theme.accentPurple.opacity(0.15))
                        }
                        .buttonStyle(.plain)

                        HStack {
                            Text("Upcoming Reminders").font(.headline)
                            Spacer()
                            Button("See All") {
                                selectedTab = .reminders
                            }
                            .tint(Theme.accentPurple)
                            .font(.subheadline)
                        }

                        if reminderController.upcoming.isEmpty {
                            Text("No upcoming reminders.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        } else {
                            VStack(spacing: 12) {
                                ForEach(reminderController.upcoming.prefix(3)) { reminder in
                                    HStack {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(reminder.tag.color)
                                            .frame(width: 4, height: 36)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(reminder.title).font(.subheadline.weight(.semibold))
                                            Text(reminder.description).font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text(reminder.date).font(.caption).foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .background(Theme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                            }
                        }

                        if !reportController.reports.isEmpty {
                            HStack {
                                Text("Recent Reports").font(.headline)
                                Spacer()
                                NavigationLink("See All") {
                                    ReportsView()
                                }
                                .tint(Theme.accentPurple)
                                .font(.subheadline)
                            }

                            VStack(spacing: 12) {
                                ForEach(reportController.reports.prefix(3)) { report in
                                    NavigationLink {
                                        ReportDetailsView(report: report)
                                    } label: {
                                        ReportRow(report: report)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(24)
                    .foregroundStyle(.black)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    var tint: Color = Theme.accentYellow

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding()
        .background(tint)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .foregroundStyle(.black)
    }
}

#Preview {
    DashboardView(selectedTab: .constant(.dashboard))
        .environmentObject(AuthController())
        .environmentObject(CatController())
        .environmentObject(ReminderController())
        .environmentObject(ReportController())
}
