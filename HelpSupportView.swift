//
//  HelpSupportView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct HelpSupportView: View {
    private let faqs: [(question: String, answer: String)] = [
        ("How do I report a stray cat?",
         "Open Reports from the Dashboard, tap the + button, fill in the details, add a photo if you can, and submit."),
        ("What do the report statuses mean?",
         "Needs Assistance: just reported. Under Observation: rescuers are checking on the cat. Rescued: the cat is safe. Adopted: the cat found a home. Resolved: the case is closed."),
        ("How do I add a care reminder?",
         "Go to the Reminders tab, tap the + button, choose a category and time, then save."),
        ("How do I mark a reminder as done?",
         "Tap the circle on the right side of the reminder. Press and hold a reminder to delete it."),
        ("How do I remove a cat?",
         "Open the cat from My Cats and tap the trash icon at the top right.")
    ]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: "Help & Support")

                    Text("Frequently Asked Questions")
                        .font(.headline)

                    VStack(spacing: 12) {
                        ForEach(faqs, id: \.question) { faq in
                            DisclosureGroup {
                                Text(faq.answer)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 6)
                            } label: {
                                Text(faq.question)
                                    .font(.subheadline.weight(.semibold))
                                    .multilineTextAlignment(.leading)
                            }
                            .tint(.black)
                            .padding()
                            .background(Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    Text("Contact").font(.headline)

                    if let url = URL(string: "mailto:support@catlink.app") {
                        Link(destination: url) {
                            SettingsRowLabel(icon: "envelope.fill", title: "Email Support")
                        }
                    }

                    Text("Legal").font(.headline)

                    NavigationLink {
                        TermsOfServiceView()
                    } label: {
                        SettingsRowLabel(icon: "doc.text.fill", title: "Terms of Service")
                    }

                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        SettingsRowLabel(icon: "lock.shield.fill", title: "Privacy Policy")
                    }
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
    NavigationStack { HelpSupportView() }
}
