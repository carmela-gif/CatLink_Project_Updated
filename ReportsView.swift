//
//  ReportsView.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var reportController: ReportController

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(title: "Reports") {
                        NavigationLink {
                            AddReportView()
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(width: 36, height: 36)
                                .background(Theme.accentYellow)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Report a stray cat")
                    }

                    if reportController.reports.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.title)
                                .foregroundStyle(.secondary)
                            Text("No reports yet")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            NavigationLink {
                                AddReportView()
                            } label: {
                                Text("Report a Stray Cat")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Theme.accentYellow)
                                    .clipShape(Capsule())
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(reportController.reports) { report in
                                NavigationLink {
                                    ReportDetailsView(report: report)
                                } label: {
                                    ReportRow(report: report)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(24)
                .foregroundStyle(.black)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        ReportsView()
    }
    .environmentObject(ReportController())
}
