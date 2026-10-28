//
//  LoginView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authController: AuthController
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showError = false
    @State private var showForgotPassword = false
    @FocusState private var focusedField: Field?

    private enum Field { case username, password }

    private var canLogin: Bool { !username.trimmed.isEmpty && !password.isEmpty }

    private func attemptLogin() {
        guard canLogin else { return }
        showError = !authController.login(username: username.trimmed, password: password)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "cat.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 150)
                        .background(Theme.accentYellow.opacity(0.7))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Theme.accentYellow, lineWidth: 4))

                    Text("CatLink")
                        .font(.largeTitle.bold())

                    Text("Local Life and Animal Management")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    if authController.justRegistered {
                        Label("Account created! Please log in.", systemImage: "checkmark.circle.fill")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.green)
                    }

                    VStack(spacing: 14) {
                        TextField("Username or Email", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                            .roundedField()

                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit(attemptLogin)
                            } else {
                                SecureField("Password", text: $password)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit(attemptLogin)
                            }

                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .roundedField()

                        Button("Forgot Password?") {
                            showForgotPassword = true
                        }
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .tint(Theme.accentPurple)
                    }

                    if showError {
                        Text("Invalid username/email or password.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }

                    Button(action: attemptLogin) {
                        Text("Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accentYellow)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(!canLogin)

                    HStack {
                        Text("Don't have an account?")
                        NavigationLink("Register") {
                            RegistrationView()
                        }
                        .tint(Theme.accentPurple)
                    }
                    .font(.footnote)

                    Spacer()
                }
                .padding(24)
                .foregroundStyle(.black)
            }
            .onChange(of: username) { _, _ in showError = false }
            .onChange(of: password) { _, _ in showError = false }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthController())
        .environmentObject(CatController())
        .environmentObject(ReminderController())
        .environmentObject(ReportController())
}
