//
//  LegalViews.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

private struct LegalSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

private struct LegalDocumentView: View {
    let title: String
    let lastUpdated: String
    let intro: String
    let sections: [LegalSection]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: title)

                    Text("Last updated: \(lastUpdated)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(intro)
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.8))

                    ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(index + 1). \(section.title)")
                                .font(.headline)
                            Text(section.body)
                                .font(.subheadline)
                                .foregroundStyle(.black.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        LegalDocumentView(
            title: "Terms of Service",
            lastUpdated: "October 27, 2026",
            intro: "Welcome to CatLink. By creating an account or using the app, you agree to these Terms. If you do not agree, please do not use CatLink.",
            sections: [
                LegalSection(title: "Using CatLink",
                             body: "CatLink helps you manage your cats' care and report stray cats that need help. You agree to use the app only for lawful purposes and to give accurate information."),
                LegalSection(title: "Your Account",
                             body: "You are responsible for keeping your login details secure and for all activity under your account. Tell us right away if you think someone else has accessed it."),
                LegalSection(title: "Stray Cat Reports",
                             body: "Reports must be truthful and made in good faith. Do not submit false, misleading, or harassing reports. Reports and photos you submit may be reviewed by CatLink administrators and rescue partners to coordinate help."),
                LegalSection(title: "Not Emergency or Veterinary Advice",
                             body: "CatLink is not an emergency service and does not provide veterinary advice. Reminders and care information are for convenience only. For urgent situations, contact a licensed veterinarian or local animal rescue directly."),
                LegalSection(title: "Your Content",
                             body: "You keep ownership of the photos and text you submit. By submitting them, you allow CatLink to store, display, and share them as needed to run the app and process reports."),
                LegalSection(title: "Prohibited Conduct",
                             body: "Do not misuse the app, attempt to access other users' data, upload harmful or unlawful content, or interfere with how CatLink works."),
                LegalSection(title: "Administrators",
                             body: "Administrators may update the status of reports, and may remove content or suspend accounts that violate these Terms."),
                LegalSection(title: "Limitation of Liability",
                             body: "CatLink is provided \"as is\". We do not guarantee that a reported cat will be rescued or that the app will always be available or error-free. To the extent permitted by law, we are not liable for losses arising from your use of the app."),
                LegalSection(title: "Changes to These Terms",
                             body: "We may update these Terms from time to time. Continued use of CatLink after changes means you accept the updated Terms."),
                LegalSection(title: "Contact Us",
                             body: "Questions about these Terms? Email support@catlink.app.")
            ]
        )
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        LegalDocumentView(
            title: "Privacy Policy",
            lastUpdated: "October 27, 2026",
            intro: "Your privacy matters to us. This policy explains what information CatLink collects, how we use it, and the choices you have.",
            sections: [
                LegalSection(title: "Information We Collect",
                             body: "Account details (name, email, username), information about your cats (name, breed, age, weight, health notes), care reminders, and stray cat reports including descriptions, locations, dates, conditions, and photos you choose to upload."),
                LegalSection(title: "How We Use Your Information",
                             body: "To run the app and your account, send care reminders, process and track stray cat reports, let administrators update report status, and improve CatLink."),
                LegalSection(title: "Photos and Location",
                             body: "Photos are only accessed when you choose one in the photo picker. Report locations are text you enter; we do not track your device location in the background."),
                LegalSection(title: "Sharing Your Information",
                             body: "Stray cat reports (description, location, condition, photo, and status) may be visible to CatLink administrators and rescue partners so they can help. We do not sell your personal information."),
                LegalSection(title: "Data Storage and Security",
                             body: "We take reasonable steps to protect your information. No system is completely secure, so we cannot guarantee absolute security."),
                LegalSection(title: "Data Retention",
                             body: "We keep your information while your account is active. Reports may be kept longer to maintain a record of rescue activity."),
                LegalSection(title: "Your Rights",
                             body: "You may access, correct, or request deletion of your personal information, and withdraw your consent where applicable, by contacting us."),
                LegalSection(title: "Children's Privacy",
                             body: "CatLink is not intended for children under 13, and we do not knowingly collect their information."),
                LegalSection(title: "Changes to This Policy",
                             body: "We may update this policy from time to time and will update the date above when we do."),
                LegalSection(title: "Contact Us",
                             body: "Privacy questions or requests? Email privacy@catlink.app.")
            ]
        )
    }
}

#Preview("Terms") {
    NavigationStack { TermsOfServiceView() }
}

#Preview("Privacy") {
    NavigationStack { PrivacyPolicyView() }
}
