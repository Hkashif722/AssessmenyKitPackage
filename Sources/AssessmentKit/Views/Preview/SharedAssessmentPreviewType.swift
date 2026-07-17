//
//  SharedAssessmentPreviewType.swift
//  AssessmentKit
//

import SwiftUI

public struct SharedAssessmentPreviewType: View {
    public var contentType: ContentType?
    public var resourceURL: URL?

    public init(
        contentType: ContentType?,
        resourceURL: URL?
    ) {
        self.contentType = contentType
        self.resourceURL = resourceURL
    }

    public var body: some View {
        previewContent
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .background(Color(hex: "F5F5F7"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.lightGray), lineWidth: 5)
            )
    }

    @ViewBuilder
    private var previewContent: some View {
        switch (contentType, resourceURL) {
        case (.some(.textVideo), .some(let url)):
            AssessmentVideoPreview(url: url)

        case (.some(.imageText), .some(let url)),
             (.some(.image), .some(let url)),
             (.some(.subjectiveImage), .some(let url)):
            AssessmentImagePreviewView(url: url)

        case (.some(.textAudio), .some(let url)):
            AssessmentAudioPlayerView(audioURL: url)

        default:
            EmptyView()
        }
    }
}

#if DEBUG
struct SharedAssessmentPreviewType_Previews: PreviewProvider {
    static var previews: some View {
        SharedAssessmentPreviewType(
            contentType: .imageText,
            resourceURL: URL(string: "https://example.com/sample.jpg")!
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
