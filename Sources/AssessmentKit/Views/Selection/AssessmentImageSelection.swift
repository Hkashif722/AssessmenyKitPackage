//
//  AssessmentImageSelection.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct AssessmentImageSelection<Option: AssessmentOptionProtocol> {

    @Environment(\.router) var router

    public let options: [Option]
    @State private var isGridView: Bool = false

    public var onOptionTap: ((Option) -> Void)?
    public var applySegment: Bool = false

    public init(
        options: [Option],
        onOptionTap: ((Option) -> Void)? = nil,
        applySegment: Bool = false
    ) {
        self.options = options
        self.onOptionTap = onOptionTap
        self.applySegment = applySegment
    }
}

extension AssessmentImageSelection: View {

    public var body: some View {
        VStack {
            segmentControllerView
            ScrollView {
                imageOptionView
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var segmentControllerView: some View {
        if applySegment {
            Picker("View Style", selection: $isGridView) {
                Text("Grid").tag(true)
                Text("List").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }

    @ViewBuilder
    private var imageOptionView: some View {
        if isGridView {
            gridOptionView
        } else {
            listOptionView
        }
    }

    private var gridOptionView: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 8
        ) {
            ForEach(options) { option in
                ImageOptionCard(
                    option: option,
                    isGrid: isGridView,
                    onImageTap: { didSelectImage(option.imagePath) }
                ) {
                    toggleSelection(for: option)
                }
            }
        }
        .padding(5)
    }

    private var listOptionView: some View {
        VStack(spacing: 16) {
            ForEach(options) { option in
                ImageOptionCard(
                    option: option,
                    isGrid: isGridView,
                    onImageTap: { didSelectImage(option.imagePath) }
                ) {
                    toggleSelection(for: option)
                }
            }
        }
        .padding(5)
    }
}

// MARK: - Actions

extension AssessmentImageSelection {

    private func toggleSelection(for option: Option) {
        onOptionTap?(option)
    }

    private func didSelectImage(_ imgPath: URL?) {
        let model = NavigationViewModel.ZoomableViewNavModel(url: imgPath)
        Task {
            await MainActor.run {
                NavigationService.shared.navigate(using: router, to: .zoomableImageView(model))
            }
        }
    }
}
