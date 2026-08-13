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

        public static var feedbackEmojis: [FeedbackEmojiModel] {
            [
                .init(imageName: "emoji_sad", label: "assessment.emoji.poor".localized, ratingValue: 1),
                .init(imageName: "emoji_fair", label: "assessment.emoji.fair".localized, ratingValue: 2),
                .init(imageName: "emoji_neutral", label: "assessment.emoji.average".localized, ratingValue: 3),
                .init(imageName: "emoji_smiling", label: "assessment.emoji.good".localized, ratingValue: 4),
                .init(imageName: "emoji_happy", label: "assessment.emoji.excellent".localized, ratingValue: 5)
            ]
        }
    }
}
