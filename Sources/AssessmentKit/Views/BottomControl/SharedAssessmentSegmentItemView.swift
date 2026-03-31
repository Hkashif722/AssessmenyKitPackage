//
//  SharedAssessmentSegmentItemView.swift
//  AssessmentKit
//

import SwiftUI

struct SharedAssessmentSegmentItemView<ID: Hashable>: View {

    let segmentModel: SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<ID>
    var onSegmentSelect: ((Int) -> Void)?

    var body: some View {
        segmentItemView
            .onTapGesture {
                // sequenceNo is 1-based; convert to 0-based index
                onSegmentSelect?(max(segmentModel.sequenceNo - 1, 0))
            }
    }

    private var segmentItemView: some View {
        Text(segmentModel.segmentTextRepresentable)
            .font(.callout)
            .padding(8)
            .background(segmentModel.colorState.getBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(segmentModel.colorState.getBorderColor, lineWidth: 2)
            )
    }
}

#if DEBUG
#Preview {
    SharedAssessmentSegmentItemView(
        segmentModel: SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel.attempted
    )
}
#endif
