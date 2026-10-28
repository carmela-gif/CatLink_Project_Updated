//
//  AddCatView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct AddCatView: View {
    @EnvironmentObject var catController: CatController
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var breed = ""
    @State private var colorPattern = ""
    @State private var age = ""
    @State private var weight = ""
    @State private var gender = "Female"
    @State private var health = ""
    @State private var imageData: Data?

    private var canSave: Bool {
        !name.trimmed.isEmpty && !breed.trimmed.isEmpty
    }

    private func saveCat() {
        guard canSave else { return }
        let cat = Cat(
            name: name.trimmed,
            breed: breed.trimmed,
            age: age.trimmed.isEmpty ? "Unknown" : age.trimmed,
            weight: weight.trimmed.isEmpty ? "Unknown" : weight.trimmed,
            gender: gender,
            healthInformation: health.trimmed,
            colorPattern: colorPattern.trimmed,
            imageData: imageData
        )
        catController.addCat(cat)
        dismiss()
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: "Add Cat")

                    Group {
                        Text("Cat Name").font(.subheadline).fontWeight(.semibold)
                        TextField("Luna", text: $name).roundedField()
                    }

                    Group {
                        Text("Breed").font(.subheadline).fontWeight(.semibold)
                        TextField("British Shorthair", text: $breed).roundedField()
                    }

                    Group {
                        Text("Color Pattern (optional)").font(.subheadline).fontWeight(.semibold)
                        TextField("Lilac-Cream", text: $colorPattern).roundedField()
                    }

                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age").font(.subheadline).fontWeight(.semibold)
                            TextField("1 Year", text: $age).roundedField()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weight").font(.subheadline).fontWeight(.semibold)
                            TextField("4.2 kg", text: $weight).roundedField()
                        }
                    }

                    Group {
                        Text("Gender").font(.subheadline).fontWeight(.semibold)
                        HStack(spacing: 0) {
                            genderButton("Male")
                            genderButton("Female")
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Capsule())
                    }

                    Group {
                        Text("Health Information").font(.subheadline).fontWeight(.semibold)
                        TextField("Allergies, vaccinations, notes...", text: $health, axis: .vertical)
                            .lineLimit(3...6)
                            .roundedField()
                    }

                    Group {
                        Text("Add Cat Photo").font(.subheadline).fontWeight(.semibold)
                        PhotoPickerField(prompt: "Tap to add Cat photo", imageData: $imageData)
                    }

                    Button(action: saveCat) {
                        Text("Add Cat")
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

    private func genderButton(_ value: String) -> some View {
        Button {
            gender = value
        } label: {
            Text(value)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(gender == value ? Color.white : Color.clear)
                .clipShape(Capsule())
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    AddCatView()
        .environmentObject(CatController())
}
