//
//  AssessmentAudioPlayerView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct AssessmentAudioPlayerView: View {
    public let audioURL: URL

    public init(audioURL: URL) {
        self.audioURL = audioURL
    }

    public var body: some View {
        VStack {
            AudioPlayerView(audioURL: audioURL)
        }
    }
}

#if DEBUG
#Preview {
    AssessmentAudioPlayerView(
        audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!
    )
}
#endif
