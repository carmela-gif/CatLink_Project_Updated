//
//  ForgotPasswordView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authController: AuthController
    @Environment(\.dismiss) private var dismiss

    @State private var identifier = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var errorMessage: String?
    @State private var didReset = false

    private var passwordError: String? {
        if !newPassword.isEmpty && !Validator.isValidPassword(newPassword) {
            return "Use at least 6 characters."
        }
        if !confirmPassword.isEmpty && confirmPassword != newPassword {
            return "Passwords don't match."
        }
        return nil
    }

    private var canSubmit: Bool {
        !identifier.trimmed.isEmpty &&
        Validator.isValidPassword(newPassword) &&
        newPassword == confirmPassword
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Reset Password")
                            .font(.title2.bold())
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Close")
                    }

                    if didReset {
                        VStack(spacing: 14) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 56))
                                .foregroundStyle(.green)
                            Text("Password updated")
                                .font(.headline)
                            Text("You can now log in with your new password.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button {
                                dismiss()
                            } label: {
                                Text("Back to Login")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Theme.accentYellow)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                    } else {
                        Text("Enter your username or email and choose a new password.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Group {
                            Text("Username or Email").font(.subheadline).fontWeight(.semibold)
                            TextField("e.g. annie_aureada", text: $identifier)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .roundedField()
                        }

                        Group {
                            Text("New Password").font(.subheadline).fontWeight(.semibold)
                            HStack {
                                if showPassword {
                                    TextField("At least 6 characters", text: $newPassword)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("At least 6 characters", text: $newPassword)
                                }
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .roundedField()

                            SecureField("Confirm new password", text: $confirmPassword)
                                .roundedField()
                        }

                        if let passwordError { FieldError(text: passwordError) }
                        if let errorMessage { FieldError(text: errorMessage) }

                        Button {
                            if authController.resetPassword(identifier: identifier, newPassword: newPassword) {
                                didReset = true
                            } else {
                                errorMessage = "No account found with that username or email."
                            }
                        } label: {
                            Text("Reset Password")
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
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .onChange(of: identifier) { _, _ in errorMessage = nil }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthController())
}
