//
//  Components.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI
import PhotosUI

struct ScreenHeader<Trailing: View>: View {
    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let showsBack: Bool
    private let trailing: Trailing

    init(title: String, showsBack: Bool = true, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.showsBack = showsBack
        self.trailing = trailing()
    }

    var body: some View {
        HStack(spacing: 14) {
            if showsBack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .foregroundStyle(.black)
                }
                .accessibilityLabel("Back")
            }

            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.black)

            Spacer()

            trailing
        }
    }
}

extension ScreenHeader where Trailing == EmptyView {
    init(title: String, showsBack: Bool = true) {
        self.init(title: title, showsBack: showsBack) { EmptyView() }
    }
}

struct FieldError: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.red)
    }
}

struct PhotoPickerField: View {
    let prompt: String
    @Binding var imageData: Data?
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "camera")
                            .font(.title)
                            .foregroundStyle(Theme.accentPurple)
                        Text(prompt)
                            .foregroundStyle(Theme.accentPurple)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                            .foregroundStyle(.gray.opacity(0.5))
                    )
                }
            }

            if imageData != nil {
                Button {
                    imageData = nil
                    pickerItem = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white, .black.opacity(0.6))
                        .padding(8)
                }
                .accessibilityLabel("Remove photo")
            }
        }
        .onChange(of: pickerItem) { _, newItem in
            Task {
                guard let newItem,
                      let data = try? await newItem.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                imageData = uiImage.compressedData()
            }
        }
    }
}

struct StatusChip: View {
    let status: String
    var large = false

    var body: some View {
        Text(status)
            .font(large ? .subheadline.weight(.semibold) : .caption.weight(.semibold))
            .foregroundStyle(.black)
            .lineLimit(1)
            .padding(.horizontal, large ? 14 : 10)
            .padding(.vertical, large ? 6 : 4)
            .background(Theme.statusColor(status))
            .clipShape(Capsule())
            .fixedSize()
    }
}

struct ReportRow: View {
    let report: StrayReport

    var body: some View {
        HStack(spacing: 14) {
            thumbnail

            VStack(alignment: .leading, spacing: 2) {
                Text(report.description)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.black)
                    .lineLimit(1)
                Text(report.location)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            StatusChip(status: report.status)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let data = report.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Image(systemName: "photo.fill")
                .font(.title2)
                .foregroundStyle(Theme.accentPurple)
                .frame(width: 48, height: 48)
                .background(Theme.accentPurple.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct SettingsRowLabel: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
                .background(Theme.accentYellow.opacity(0.2))
                .clipShape(Circle())
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .foregroundStyle(.black)
    }
}
