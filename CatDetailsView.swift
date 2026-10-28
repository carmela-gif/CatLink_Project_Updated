//
//  CatDetailsView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct CatDetailsView: View {
    @EnvironmentObject var catController: CatController
    @Environment(\.dismiss) private var dismiss

    let cat: Cat

    @State private var showDeleteConfirmation = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var isHealthy: Bool {
        let info = cat.healthInformation.trimmed.lowercased()
        return info.isEmpty || info == "healthy"
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    ScreenHeader(title: "Cat Details") {
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundStyle(.red)
                        }
                        .accessibilityLabel("Delete cat")
                    }

                    photo

                    Text(cat.displayID)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())

                    LazyVGrid(columns: columns, spacing: 14) {
                        infoCard("Name", cat.name)
                        infoCard("Breed", cat.breed)
                        infoCard("Age", cat.age)
                        infoCard("Gender", cat.gender)
                        infoCard("Weight", cat.weight)
                        infoCard("Health Status",
                                 isHealthy ? "Healthy" : "See notes",
                                 valueColor: isHealthy ? .green : .orange)
                    }

                    if !cat.colorPattern.isEmpty {
                        fullWidthCard("Color Pattern", cat.colorPattern)
                    }

                    if !isHealthy {
                        fullWidthCard("Health Information", cat.healthInformation)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Logs")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(alignment: .top, spacing: 10) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.green)
                                .frame(width: 4)
                            Text("No care records yet.")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog("Delete \(cat.name)?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                catController.removeCat(cat)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This can't be undone.")
        }
    }

    @ViewBuilder
    private var photo: some View {
        if let data = cat.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
        } else {
            Image(systemName: "cat.fill")
                .font(.system(size: 50))
                .frame(width: 120, height: 120)
                .background(Color.gray.opacity(0.15))
                .clipShape(Circle())
        }
    }

    private func infoCard(_ label: String, _ value: String, valueColor: Color = .black) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.headline).foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func fullWidthCard(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    CatDetailsView(cat: Cat(
        name: "Luna", breed: "British Shorthair", age: "2 Years",
        weight: "4.2 kg", gender: "Female", healthInformation: "Healthy",
        colorPattern: "Lilac-Cream"
    ))
    .environmentObject(CatController())
}
