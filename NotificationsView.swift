//
//  NotificationsView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct NotificationsView: View {
    @AppStorage("notifyReminders") private var notifyReminders = true
    @AppStorage("notifyReports") private var notifyReports = true
    @State private var showDeniedAlert = false

    private func toggleBinding(_ value: Binding<Bool>) -> Binding<Bool> {
        Binding(
            get: { value.wrappedValue },
            set: { newValue in
                value.wrappedValue = newValue
                guard newValue else { return }
                NotificationScheduler.requestPermission { granted in
                    if !granted {
                        value.wrappedValue = false
                        showDeniedAlert = true
                    }
                }
            }
        )
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: "Notifications")

                    VStack(spacing: 0) {
                        Toggle(isOn: toggleBinding($notifyReminders)) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Care reminders").font(.subheadline.weight(.semibold))
                                Text("Get alerted when a reminder is due.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .tint(Theme.accentYellow)
                        .padding()

                        Divider().padding(.horizontal)

                        Toggle(isOn: toggleBinding($notifyReports)) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Report updates").font(.subheadline.weight(.semibold))
                                Text("Know when a stray report changes status.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .tint(Theme.accentYellow)
                        .padding()
                    }
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Text("Reminders you create after turning this on will alert you at the time you choose.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .alert("Notifications are off", isPresented: $showDeniedAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Allow notifications for CatLink in your iPhone settings to get alerts.")
        }
    }
}

#Preview {
    NotificationsView()
}
