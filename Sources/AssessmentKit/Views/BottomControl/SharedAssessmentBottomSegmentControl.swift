//
//  SharedAssessmentBottomSegmentControl.swift
//  AssessmentKit
//

import SwiftUI

/// Public entry point for the scrollable question-navigator strip.
///
/// - When `showNavigationButtons` is `true` (default), left/right chevron
///   buttons flank the segment list and drive pagination.
/// - When `false`, only the scrollable strip is rendered — useful when the
///   host already provides prev/next buttons (e.g. `SharedAssessmentBottomControlView`).
public struct SharedAssessmentBottomSegmentControl<IDType: Hashable>: View {

    public let segmentDataModel: [SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<IDType>]
    public let selectedIndex: Int
    public var showNavigationButtons: Bool
    public var showSelectionIndicator: Bool
    public var onSegmentChange: ((Int) -> Void)?

    public init(
        segmentDataModel: [SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<IDType>],
        selectedIndex: Int = 0,
        showNavigationButtons: Bool = true,
        showSelectionIndicator: Bool = true,
        onSegmentChange: ((Int) -> Void)? = nil
    ) {
        self.segmentDataModel = segmentDataModel
        self.selectedIndex = selectedIndex
        self.showNavigationButtons = showNavigationButtons
        self.showSelectionIndicator = showSelectionIndicator
        self.onSegmentChange = onSegmentChange
    }

    public var body: some View {
        Group {
            if showNavigationButtons {
                navigationControlView
            } else {
                segmentListOnly
            }
        }
    }

    // MARK: - Private

    private var navigationControlView: some View {
        SharedAssessmentSegmentControlView(
            initialIndex: selectedIndex,
            totalCount: segmentDataModel.count,
            onIndexChanged: { onSegmentChange?($0) }
        ) { currentIndex in
            SharedAssessmentSegmentListView(
                segmentDataModel: segmentDataModel,
                selectedIndex: currentIndex,
                showSelectionIndicator: showSelectionIndicator,
                onSegmentSelect: { onSegmentChange?($0) }
            )
        }
    }

    private var segmentListOnly: some View {
        SharedAssessmentSegmentListView(
            segmentDataModel: segmentDataModel,
            selectedIndex: selectedIndex,
            showSelectionIndicator: showSelectionIndicator,
            onSegmentSelect: { onSegmentChange?($0) }
        )
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    struct PreviewWrapper: View {
        @State private var currentIndex = 0
        let segments = SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel
            .makeSampleSegments(count: 10)

        var body: some View {
            VStack(spacing: 30) {
                Text("With navigation buttons — Q\(currentIndex + 1) of \(segments.count)")
                    .font(.headline)

                SharedAssessmentBottomSegmentControl(
                    segmentDataModel: segments,
                    selectedIndex: currentIndex,
                    onSegmentChange: { currentIndex = $0 }
                )

                Divider()

                Text("List only (no buttons)")
                    .font(.headline)

                SharedAssessmentBottomSegmentControl(
                    segmentDataModel: segments,
                    selectedIndex: currentIndex,
                    showNavigationButtons: false,
                    onSegmentChange: { currentIndex = $0 }
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
#endif
