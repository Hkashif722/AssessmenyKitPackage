//
//  EmojiFeedbackView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct EmojiFeedbackView {
    @State private var selectedIndex: Int = 0
    @State private var isSelected: Bool = false

    public let feedbackEmojiSelectable: Bool
    public var getRatingValue: (() -> Int)?
    public var onFeedbackSelect: ((_ ratingValue: Int) -> Void)?

    public let feedbackEmojis: [FeedbackDetailDataModel.FeedbackEmojiModel] = FeedbackDetailDataModel.FeedbackEmojiModel.feedbackEmojis

    public init(
        feedbackEmojiSelectable: Bool = true,
        getRatingValue: (() -> Int)? = nil,
        onFeedbackSelect: ((_ ratingValue: Int) -> Void)? = nil
    ) {
        self.feedbackEmojiSelectable = feedbackEmojiSelectable
        self.getRatingValue = getRatingValue
        self.onFeedbackSelect = onFeedbackSelect
    }
}

extension EmojiFeedbackView: View {

    public var body: some View {
        VStack(spacing: 16) {
            emojiView
            emojiLabelView
        }
        .padding()
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(Color(.lightGray).opacity(0.7), lineWidth: 1)
        }
        .onAppear {
            updateSelectedIndex()
        }
        .onChange(of: getRatingValue?()) { _ in
            updateSelectedIndex()
        }
    }

    // MARK: - Subviews

    private var emojiView: some View {
        HStack(spacing: 20) {
            ForEach(feedbackEmojis.indices, id: \.self) { index in
                emojiImageView(emoji: feedbackEmojis[index], index: index)
            }
        }
    }

    private func emojiImageView(
        emoji: FeedbackDetailDataModel.FeedbackEmojiModel,
        index: Int
    ) -> some View {
        Image(emoji.imageName, bundle: .assessmentKit)
            .renderingMode(.template)
            .resizable()
            .scaledToFill()
            .frame(width: 45, height: 45)
            .foregroundColor(
                (selectedIndex == index && isSelected)
                ? ColorUtility.deepYellow
                : .gray
            )
            .onTapGesture {
                guard feedbackEmojiSelectable else { return }
                selectedIndex = index
                if !isSelected { isSelected = true }
                onFeedbackSelect?(emoji.ratingValue)
                Logger.shared.log(.info, message: "rating: \(emoji.ratingValue)")
            }
            .animation(.easeInOut, value: isSelected)
    }

    @ViewBuilder
    private var emojiLabelView: some View {
        if isSelected {
            Text(feedbackEmojis[selectedIndex].label)
                .font(.title3)
                .versionedLineLimitPkg()
        }
    }

    // MARK: - Helpers

    private func updateSelectedIndex() {
        guard let rating = getRatingValue?() else { return }
        selectedIndex = min(max(rating - 1, 0), 4)
        isSelected = rating > 0
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var rating: Int = 0

    VStack {
        EmojiFeedbackView(getRatingValue: {
            rating
        }) { ratingValue in
            Logger.shared.log(.info, message: "rating: \(ratingValue)")
        }
        .padding()

        Button("Change Rating") {
            rating = 4
        }
    }
}
