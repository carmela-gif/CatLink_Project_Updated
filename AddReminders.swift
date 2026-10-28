//
//  AddReminders.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct AddReminderView: View {
    @EnvironmentObject var reminderController: ReminderController
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var tag: ReminderTag = .feeding

    private let categoryColumns = [GridItem(.flexible()), GridItem(.flexible())]

    private var canSave: Bool { !title.trimmed.isEmpty }

    private func saveReminder() {
        guard canSave else { return }
        let reminder = CareReminder(
            title: title.trimmed,
            description: description.trimmed,
            date: Formatters.reminderDate(dueDate),
            tag: tag
        )
        reminderController.addReminder(reminder, dueDate: dueDate)
        dismiss()
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: "Add a Reminder")

                    Group {
                        Text("Reminder Title").font(.subheadline).fontWeight(.semibold)
                        TextField("e.g. Feed Luna", text: $title)
                            .roundedField()
                    }

                    Group {
                        Text("Description").font(.subheadline).fontWeight(.semibold)
                        TextField("e.g. Wet food • 1/2 can", text: $description, axis: .vertical)
                            .roundedField()
                    }

                    Group {
                        Text("Date & Time").font(.subheadline).fontWeight(.semibold)
                        HStack {
                            Image(systemName: "calendar").foregroundStyle(.secondary)
                            DatePicker("", selection: $dueDate, in: Date()...,
                                       displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .datePickerStyle(.compact)
                            Spacer()
                        }
                        .roundedField()
                    }

                    Group {
                        Text("Category").font(.subheadline).fontWeight(.semibold)
                        LazyVGrid(columns: categoryColumns, spacing: 10) {
                            ForEach(ReminderTag.allCases, id: \.self) { option in
                                categoryButton(option)
                            }
                        }
                    }

                    Button(action: saveReminder) {
                        Text("Add Reminder")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accentYellow)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(!canSave)
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }

    private func categoryButton(_ option: ReminderTag) -> some View {
        Button {
            tag = option
        } label: {
            Label(option.title, systemImage: option.icon)
                .font(.footnote.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(tag == option ? option.color.opacity(0.3) : Color.white)
                .foregroundStyle(tag == option ? .black : .gray)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(tag == option ? option.color : Color.clear, lineWidth: 1.5)
                )
        }
    }
}

#Preview {
    AddReminderView()
        .environmentObject(ReminderController())
}
