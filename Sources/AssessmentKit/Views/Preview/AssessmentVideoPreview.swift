//
//  AssessmentVideoPreview.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct AssessmentVideoPreview: View {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        UIKitComponentRepresentable.PlayerKitView(videoURL: url)
    }
}

#if DEBUG
#Preview {
    AssessmentVideoPreview(
        url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    )
}
#endif
