//
//  ProfileView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var catController: CatController
    @EnvironmentObject var reminderController: ReminderController
    @Binding var selectedTab: AppTab

    @State private var showLogoutConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        avatar

                        VStack(spacing: 4) {
                            Text(authController.user.fullName)
                                .font(.title2.bold())
                            Text(authController.user.email)
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            statColumn(value: "\(catController.cats.count)", label: "Cats Managed")
                            Divider().frame(height: 40)
                            statColumn(value: "\(reminderController.upcoming.count)", label: "Reminders Set")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        NavigationLink {
                            EditProfileView()
                        } label: {
                            Text("Edit Profile")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.accentYellow)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Settings & Preferences")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button {
                                selectedTab = .cats
                            } label: {
                                SettingsRowLabel(icon: "cat.fill", title: "My Cats")
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                NotificationsView()
                            } label: {
                                SettingsRowLabel(icon: "bell.fill", title: "Notifications")
                            }

                            NavigationLink {
                                HelpSupportView()
                            } label: {
                                SettingsRowLabel(icon: "questionmark.circle.fill", title: "Help & Support")
                            }

                            Button(role: .destructive) {
                                showLogoutConfirmation = true
                            } label: {
                                Text("Logout")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .background(Color.red.opacity(0.12))
                            .foregroundStyle(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(24)
                    .foregroundStyle(.black)
                }
            }
            .navigationBarHidden(true)
            .confirmationDialog("Log out of CatLink?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                Button("Log Out", role: .destructive) {
                    authController.logout()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    @ViewBuilder
    private var avatar: some View {
        if let data = authController.user.profileImageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Theme.accentYellow, lineWidth: 4))
        } else {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.gray.opacity(0.6))
        }
    }

    private func statColumn(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView(selectedTab: .constant(.profile))
        .environmentObject(AuthController())
        .environmentObject(CatController())
        .environmentObject(ReminderController())
        .environmentObject(ReportController())
}
