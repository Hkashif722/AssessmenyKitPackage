//
//  OptionModel.swift
//  AssessmentKit
//

import Foundation

/// Concrete option model conforming to ``AssessmentOptionProtocol``.
public struct OptionModel: AssessmentOptionProtocol {
    public var id: UUID
    public var title: String
    public var imagePath: URL?
    public var isSelected: Bool
    public var questionID: Int?
    public var optionText: String?
    public var selectedOptionId: Int32?
    public var isReview: Bool
    public var isCorrectAnswer: Bool?

    public init(
        id: UUID = UUID(),
        title: String,
        imagePath: URL? = nil,
        isSelected: Bool = false,
        questionID: Int? = nil,
        optionText: String? = nil,
        selectedOptionId: Int32? = nil,
        isReview: Bool = false,
        isCorrectAnswer: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.isSelected = isSelected
        self.questionID = questionID
        self.optionText = optionText
        self.selectedOptionId = selectedOptionId
        self.isReview = isReview
        self.isCorrectAnswer = isCorrectAnswer
    }
}

/// Convenience typealias used throughout the package.
/// Views reference `SharedAssessmentOptionModel` so callers can swap the
/// concrete type without touching every call-site.
public typealias SharedAssessmentOptionModel = OptionModel
