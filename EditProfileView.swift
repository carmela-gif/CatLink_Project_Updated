//
//  EditProfileView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var authController: AuthController
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var username = ""
    @State private var imageData: Data?
    @State private var pickerItem: PhotosPickerItem?
    @State private var errorMessage: String?

    private var canSave: Bool { !name.trimmed.isEmpty && !email.trimmed.isEmpty && !username.trimmed.isEmpty }

    private func save() {
        if let error = authController.updateProfile(
            fullName: name, email: email, username: username, imageData: imageData
        ) {
            errorMessage = error
        } else {
            dismiss()
        }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    ScreenHeader(title: "Edit Profile")

                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.gray.opacity(0.6))
                            }
                        }
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Theme.accentYellow, lineWidth: 5))

                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            Image(systemName: "camera.fill")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Theme.accentYellow)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Change photo")
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: pickerItem) { _, newItem in
                        Task {
                            guard let newItem,
                                  let data = try? await newItem.loadTransferable(type: Data.self),
                                  let uiImage = UIImage(data: data) else { return }
                            imageData = uiImage.compressedData(maxDimension: 600)
                        }
                    }

                    if imageData != nil {
                        Button("Remove photo") {
                            imageData = nil
                            pickerItem = nil
                        }
                        .font(.footnote)
                        .tint(.red)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Name").font(.subheadline).fontWeight(.semibold)
                        TextField("Name", text: $name)
                            .textContentType(.name)
                            .roundedField()

                        Text("Email Address").font(.subheadline).fontWeight(.semibold)
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .roundedField()

                        Text("Username").font(.subheadline).fontWeight(.semibold)
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .roundedField()

                        if let errorMessage {
                            FieldError(text: errorMessage)
                        }
                    }

                    Button(action: save) {
                        Text("Save Changes")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
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
        .onAppear {
            name = authController.user.fullName
            email = authController.user.email
            username = authController.user.username
            imageData = authController.user.profileImageData
        }
        .onChange(of: name) { _, _ in errorMessage = nil }
        .onChange(of: email) { _, _ in errorMessage = nil }
        .onChange(of: username) { _, _ in errorMessage = nil }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthController())
}
