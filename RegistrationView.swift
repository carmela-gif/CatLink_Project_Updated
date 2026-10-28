//
//  RegistrationView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authController: AuthController
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var acceptedTerms = false
    @State private var errorMessage: String?

    private var emailError: String? {
        email.isEmpty || Validator.isValidEmail(email.trimmed) ? nil : "Enter a valid email address."
    }

    private var usernameError: String? {
        username.isEmpty || Validator.isValidUsername(username.trimmed)
            ? nil : "At least 3 characters, no spaces."
    }

    private var passwordError: String? {
        password.isEmpty || Validator.isValidPassword(password) ? nil : "Use at least 6 characters."
    }

    private var isFormValid: Bool {
        !fullName.trimmed.isEmpty &&
        Validator.isValidEmail(email.trimmed) &&
        Validator.isValidUsername(username.trimmed) &&
        Validator.isValidPassword(password) &&
        acceptedTerms
    }

    private func createAccount() {
        guard isFormValid else { return }
        if let error = authController.register(
            fullName: fullName,
            email: email,
            username: username,
            password: password
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
                VStack(alignment: .leading, spacing: 18) {
                    Text("Create Account")
                        .font(.largeTitle.bold())
                        .padding(.top, 12)

                    Group {
                        Text("Full Name").font(.subheadline).fontWeight(.semibold)
                        TextField("e.g. Anne Aureada", text: $fullName)
                            .textContentType(.name)
                            .roundedField()
                    }

                    Group {
                        Text("Email Address").font(.subheadline).fontWeight(.semibold)
                        TextField("e.g. annie@email.com", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .roundedField()
                        if let emailError { FieldError(text: emailError) }
                    }

                    Group {
                        Text("Username").font(.subheadline).fontWeight(.semibold)
                        TextField("e.g. annie_aureada", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .roundedField()
                        if let usernameError { FieldError(text: usernameError) }
                    }

                    Group {
                        Text("Password").font(.subheadline).fontWeight(.semibold)
                        HStack {
                            if showPassword {
                                TextField("Create robust password", text: $password)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Create robust password", text: $password)
                            }
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .roundedField()
                        if let passwordError { FieldError(text: passwordError) }
                    }

                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            acceptedTerms.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(acceptedTerms ? Theme.accentYellow : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.4)))
                                .frame(width: 24, height: 24)
                                .overlay {
                                    if acceptedTerms {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.black)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Agree to Terms of Service and Privacy Policy")

                        VStack(alignment: .leading, spacing: 2) {
                            Text("I agree to the")
                                .foregroundStyle(.secondary)
                            HStack(spacing: 4) {
                                NavigationLink("Terms of Service") { TermsOfServiceView() }
                                Text("and").foregroundStyle(.secondary)
                                NavigationLink("Privacy Policy") { PrivacyPolicyView() }
                            }
                            .tint(Theme.accentPurple)
                        }
                        .font(.footnote)
                    }

                    if let errorMessage {
                        FieldError(text: errorMessage)
                    }

                    Button(action: createAccount) {
                        Text("Create Account")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accentYellow)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(!isFormValid)

                    HStack {
                        Spacer()
                        Text("Already have an account?")
                        Button("Login") { dismiss() }
                            .tint(Theme.accentPurple)
                        Spacer()
                    }
                    .font(.footnote)
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: username) { _, _ in errorMessage = nil }
        .onChange(of: email) { _, _ in errorMessage = nil }
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
    .environmentObject(AuthController())
    .environmentObject(CatController())
    .environmentObject(ReminderController())
    .environmentObject(ReportController())
}
