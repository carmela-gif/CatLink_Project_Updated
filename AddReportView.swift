//
//  AddReportView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct AddReportView: View {
    @EnvironmentObject var reportController: ReportController
    @EnvironmentObject var authController: AuthController
    @Environment(\.dismiss) private var dismiss

    @State private var description = ""
    @State private var location = ""
    @State private var dateSpotted = Date()
    @State private var condition = "Injured"
    @State private var additionalInformation = ""
    @State private var imageData: Data?

    private let conditions = ["Healthy", "Injured", "Sick", "Unknown"]

    private var canSubmit: Bool {
        !description.trimmed.isEmpty && !location.trimmed.isEmpty
    }

    private func submit() {
        guard canSubmit else { return }
        let report = StrayReport(
            description: description.trimmed,
            location: location.trimmed,
            date: Formatters.reportDate(dateSpotted),
            condition: condition,
            additionalInformation: additionalInformation.trimmed,
            status: "Needs Assistance",
            reporterName: authController.user.fullName,
            imageData: imageData
        )
        reportController.addReport(report)
        dismiss()
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: "Report Stray Cat")

                    Group {
                        Text("Cat Description").font(.subheadline).fontWeight(.semibold)
                        TextField("Orange tabby, medium size", text: $description, axis: .vertical)
                            .roundedField()
                    }

                    Group {
                        Text("Location").font(.subheadline).fontWeight(.semibold)
                        HStack {
                            Image(systemName: "mappin.and.ellipse").foregroundStyle(.secondary)
                            TextField("Maple Street Park", text: $location)
                        }
                        .roundedField()
                    }

                    Group {
                        Text("Date Spotted").font(.subheadline).fontWeight(.semibold)
                        HStack {
                            Image(systemName: "calendar").foregroundStyle(.secondary)
                            DatePicker("", selection: $dateSpotted, in: ...Date(), displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                            Spacer()
                        }
                        .roundedField()
                    }

                    Group {
                        Text("Condition").font(.subheadline).fontWeight(.semibold)
                        Menu {
                            ForEach(conditions, id: \.self) { option in
                                Button(option) { condition = option }
                            }
                        } label: {
                            HStack {
                                Text(condition).foregroundStyle(.black)
                                Spacer()
                                Image(systemName: "chevron.down").foregroundStyle(.secondary)
                            }
                            .roundedField()
                        }
                    }

                    Group {
                        Text("Additional Information").font(.subheadline).fontWeight(.semibold)
                        TextField("Found near the playground entrance...", text: $additionalInformation, axis: .vertical)
                            .lineLimit(3...6)
                            .roundedField()
                    }

                    Group {
                        Text("Add Photo").font(.subheadline).fontWeight(.semibold)
                        PhotoPickerField(prompt: "Tap to add photo", imageData: $imageData)
                    }

                    Button(action: submit) {
                        Text("Submit Report")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accentYellow)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(!canSubmit)
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    AddReportView()
        .environmentObject(AuthController())
        .environmentObject(ReportController())
}
