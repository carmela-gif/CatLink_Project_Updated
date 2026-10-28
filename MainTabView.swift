//
//  MainTabView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

enum AppTab: Hashable {
    case dashboard, cats, reminders, admin, profile
}

struct MainTabView: View {
    @EnvironmentObject var authController: AuthController
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(selectedTab: $selectedTab)
                .tabItem { Label("Dashboard", systemImage: "house.fill") }
                .tag(AppTab.dashboard)

            MyCatsView()
                .tabItem { Label("My Cats", systemImage: "cat.fill") }
                .tag(AppTab.cats)

            RemindersView()
                .tabItem { Label("Reminders", systemImage: "bell.fill") }
                .tag(AppTab.reminders)

            if authController.isAdmin {
                AdminView()
                    .tabItem { Label("Admin", systemImage: "shield.lefthalf.filled") }
                    .tag(AppTab.admin)
            }

            ProfileView(selectedTab: $selectedTab)
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(AppTab.profile)
        }
        .tint(Theme.accentYellow)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthController())
        .environmentObject(CatController())
        .environmentObject(ReminderController())
        .environmentObject(ReportController())
}
