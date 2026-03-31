//
//  SharedAssessmentSegmentControlView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

/// A generic left/right navigation shell that wraps arbitrary `Content`.
/// Used internally by `SharedAssessmentBottomSegmentControl`.
struct SharedAssessmentSegmentControlView<Content: View>: View {

    let content: (Int) -> Content
    let initialIndex: Int
    let totalCount: Int
    var onBackTapped: (() -> Void)?
    var onForwardTapped: (() -> Void)?
    var onIndexChanged: ((Int) -> Void)?

    @State private var currentIndex: Int

    init(
        initialIndex: Int = 0,
        totalCount: Int,
        onBackTapped: (() -> Void)? = nil,
        onForwardTapped: (() -> Void)? = nil,
        onIndexChanged: ((Int) -> Void)? = nil,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.initialIndex = initialIndex
        self.totalCount = totalCount
        self.onBackTapped = onBackTapped
        self.onForwardTapped = onForwardTapped
        self.onIndexChanged = onIndexChanged
        self.content = content
        self._currentIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        HStack(spacing: 8) {
            SwiftUIUtility.RoundMenuButton(
                image: .system(name: "chevron.left"),
                buttonSize: 40,
                foregroundColor: ColorUtility.secondaryColor.getDynamicTextColor,
                backgroundColor: ColorUtility.secondaryColor,
                action: handleBackTapped
            )
            .disabledWithOpacityPkg(isBackDisabled)

            content(currentIndex)
                .frame(maxWidth: .infinity)

            SwiftUIUtility.RoundMenuButton(
                image: .system(name: "chevron.right"),
                buttonSize: 40,
                foregroundColor: ColorUtility.secondaryColor.getDynamicTextColor,
                backgroundColor: ColorUtility.secondaryColor,
                action: handleForwardTapped
            )
            .disabledWithOpacityPkg(isForwardDisabled)
        }
        .onChange(of: initialIndex) { newIndex in
            guard newIndex != currentIndex else { return }
            currentIndex = newIndex
        }
    }

    // MARK: - Computed

    private var isBackDisabled: Bool    { currentIndex <= 0 }
    private var isForwardDisabled: Bool { currentIndex >= totalCount - 1 }

    // MARK: - Actions

    private func handleBackTapped() {
        guard currentIndex > 0 else { return }
        onBackTapped?()
        currentIndex -= 1
        onIndexChanged?(currentIndex)
    }

    private func handleForwardTapped() {
        guard currentIndex < totalCount - 1 else { return }
        onForwardTapped?()
        currentIndex += 1
        onIndexChanged?(currentIndex)
    }
}
