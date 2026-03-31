//
//  SharedAssessmentOptionAsImageView.swift
//  AssessmentKit
//

import SwiftUI

public struct SharedAssessmentOptionAsImageView: View {
    public var options: [SharedAssessmentOptionModel]
    public var handleSelection: ((SharedAssessmentOptionModel) -> Void)?

    public init(
        options: [SharedAssessmentOptionModel],
        handleSelection: ((SharedAssessmentOptionModel) -> Void)? = nil
    ) {
        self.options = options
        self.handleSelection = handleSelection
    }

    public var body: some View {
        VStack {
            AssessmentImageSelection(
                options: options,
                onOptionTap: handleSelection
            )
        }
    }
}
