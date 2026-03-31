//
//  SharedAssessmentSegmentListView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

struct SharedAssessmentSegmentListView<ID: Hashable>: View {

    let segmentDataModel: [SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<ID>]
    let selectedIndex: Int
    var showSelectionIndicator: Bool
    var onSegmentSelect: ((Int) -> Void)?

    @State private var currentIndex: Int

    init(
        segmentDataModel: [SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<ID>],
        selectedIndex: Int,
        showSelectionIndicator: Bool = true,
        onSegmentSelect: ((Int) -> Void)? = nil
    ) {
        self.segmentDataModel = segmentDataModel
        self.selectedIndex = selectedIndex
        self.showSelectionIndicator = showSelectionIndicator
        self.onSegmentSelect = onSegmentSelect
        self._currentIndex = State(initialValue: selectedIndex)
    }

    var body: some View {
        segmentListView
            .onChange(of: selectedIndex) { newIndex in
                guard newIndex != currentIndex else { return }
                currentIndex = newIndex
            }
    }

    // MARK: - Subviews

    private var segmentListView: some View {
        ScrollViewReader { proxy in
            scrollContent
                .onChange(of: currentIndex) { newIndex in
                    scrollToSegment(at: newIndex, proxy: proxy)
                }
                .onAppear {
                    scrollToSegment(at: currentIndex, proxy: proxy)
                }
        }
    }

    private var scrollContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(segmentDataModel.indices, id: \.self) { index in
                    segmentItem(at: index)
                }
            }
        }
        .versionedHorizontalContentMarginsPkg()
    }

    private func segmentItem(at index: Int) -> some View {
        SharedAssessmentSegmentItemView(
            segmentModel: segmentDataModel[index],
            onSegmentSelect: { sequence in
                handleSegmentTap(at: sequence)
            }
        )
        .id(segmentDataModel[index].id)
        .overlay(selectionIndicator(for: index))
        .scaleEffect(selectedIndex == index ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedIndex)
    }

    @ViewBuilder
    private func selectionIndicator(for index: Int) -> some View {
        if showSelectionIndicator && selectedIndex == index {
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorUtility.primaryColor, lineWidth: 3)
        }
    }

    // MARK: - Helpers

    private func handleSegmentTap(at index: Int) {
        guard segmentDataModel.indices.contains(index) else { return }
        currentIndex = index
        onSegmentSelect?(index)
    }

    private func scrollToSegment(at index: Int, proxy: ScrollViewProxy) {
        guard segmentDataModel.indices.contains(index) else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(segmentDataModel[index].id, anchor: .center)
        }
    }
}
