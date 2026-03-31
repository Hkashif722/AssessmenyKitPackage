//
//  SharedAssessmentHeaderView.swift
//  AssessmentKit
//

import SwiftUI

public struct SharedAssessmentHeaderView: View {
    public var contentType: String
    public var questionText: AttributedString

    public init(contentType: String, questionText: AttributedString) {
        self.contentType = contentType
        self.questionText = questionText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            questionTypeLabel
            questionLabel
        }
    }

    @ViewBuilder
    private var questionTypeLabel: some View {
        if !contentType.isEmpty {
            Text(contentType)
                .font(.callout)
                .foregroundColor(Color(.lightGray))
        }
    }

    private var questionLabel: some View {
        Text(questionText)
            .font(.headline)
            .foregroundColor(Color(.label))
    }
}

#if DEBUG
struct SharedAssessmentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SharedAssessmentHeaderView(
            contentType: "Video Question",
            questionText: "What is the capital of France?"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
