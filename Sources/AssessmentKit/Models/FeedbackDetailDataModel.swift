//
//  FeedbackDetailDataModel.swift
//  AssessmentKit
//

import Foundation

public struct FeedbackDetailDataModel {

    public struct FeedbackEmojiModel: Identifiable {
        public let id = UUID()
        public let imageName: String
        public let label: String
        public let ratingValue: Int

        public init(imageName: String, label: String, ratingValue: Int) {
            self.imageName = imageName
            self.label = label
            self.ratingValue = ratingValue
        }

        public static let feedbackEmojis: [FeedbackEmojiModel] = [
            .init(imageName: "emoji_sad",     label: "Poor",      ratingValue: 1),
            .init(imageName: "emoji_fair",    label: "Fair",      ratingValue: 2),
            .init(imageName: "emoji_neutral", label: "Average",   ratingValue: 3),
            .init(imageName: "emoji_smiling", label: "Good",      ratingValue: 4),
            .init(imageName: "emoji_happy",   label: "Excellent", ratingValue: 5)
        ]
    }
}
