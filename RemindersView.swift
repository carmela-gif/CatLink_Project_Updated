//
//  RemindersView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct RemindersView: View {
    @EnvironmentObject var reminderController: ReminderController
    @State private var selectedTab: Tab = .upcoming

    enum Tab { case upcoming, completed }

    private var list: [CareReminder] {
        selectedTab == .upcoming ? reminderController.upcoming : reminderController.completed
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Reminders")
                            .font(.largeTitle.bold())

                        HStack(spacing: 0) {
                            segmentButton("Upcoming", tab: .upcoming)
                            segmentButton("Completed", tab: .completed)
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Capsule())

                        if list.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: selectedTab == .upcoming ? "bell.slash" : "checkmark.circle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                Text(selectedTab == .upcoming ? "No upcoming reminders" : "Nothing completed yet")
                                    .font(.headline)
                                Text(selectedTab == .upcoming
                                     ? "Tap the + button to add one."
                                     : "Reminders you finish will show up here.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(list) { reminder in
                                    reminderRow(reminder)
                                }
                            }

                            Text("Tap the circle to mark done. Press and hold a reminder to delete it.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(24)
                    .padding(.bottom, 80)
                    .foregroundStyle(.black)
                }

                NavigationLink {
                    AddReminderView()
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                        .frame(width: 56, height: 56)
                        .background(Theme.accentYellow)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .accessibilityLabel("Add reminder")
                .padding(24)
            }
            .navigationBarHidden(true)
        }
    }

    private func segmentButton(_ label: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == tab ? Color.white : Color.clear)
                .clipShape(Capsule())
                .foregroundStyle(.black)
        }
    }

    private func reminderRow(_ reminder: CareReminder) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(reminder.tag.color)
                .frame(width: 4, height: 44)

            Image(systemName: reminder.tag.icon)
                .foregroundStyle(.black.opacity(0.7))
                .frame(width: 40, height: 40)
                .background(reminder.tag.color.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                    .strikethrough(reminder.isCompleted)
                    .lineLimit(1)
                Text(reminder.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 6) {
                Text(reminder.date)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button {
                    reminderController.toggleComplete(reminder)
                } label: {
                    Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(reminder.isCompleted ? .green : Theme.accentPurple)
                }
                .accessibilityLabel(reminder.isCompleted ? "Mark as upcoming" : "Mark as done")
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .opacity(reminder.isCompleted ? 0.75 : 1)
        .contextMenu {
            Button {
                reminderController.toggleComplete(reminder)
            } label: {
                Label(reminder.isCompleted ? "Mark as Upcoming" : "Mark as Done",
                      systemImage: reminder.isCompleted ? "arrow.uturn.backward" : "checkmark")
            }
            Button(role: .destructive) {
                reminderController.removeReminder(reminder)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    RemindersView()
        .environmentObject(ReminderController())
}
