//
//  SharedAssessmentSelectionTypeView.swift
//  AssessmentKit
//

import SwiftUI

/// Routes the correct answer-input view based on the question's `ContentType`.
///
/// This is the primary composable entry point for the answer area of any
/// assessment question. The host passes data and closures; this view
/// picks the right child.
public struct SharedAssessmentSelectionTypeView: View {

    // MARK: - Content type

    public var contentType: ContentType?

    // MARK: - Objective / list options

    /// Options for list-based (`objective`, `textAudio`, `textVideo`, `imageText`) questions.
    public var options: [SharedAssessmentOptionModel]?
    public var optionType: OptionType?
    public var isSelected: (SharedAssessmentOptionModel) -> Bool
    public var handleSelection: ((SharedAssessmentOptionModel) -> Void)?
    public var getTitle: (SharedAssessmentOptionModel) -> String

    // MARK: - Review state

    public var isReview: (SharedAssessmentOptionModel) -> Bool
    public var isCorrectAnswer: (SharedAssessmentOptionModel) -> Bool

    // MARK: - Subjective

    public var previousAnswer: String?
    public var isSubjectiveTextViewDisabled: Bool
    public var handleSubjectiveAnswer: ((String, Bool) -> Void)?

    // MARK: - Image-option selection

    public var handleImageSelection: ((SharedAssessmentOptionModel) -> Void)?

    // MARK: - Objective/subjective with image upload

    public var imageURL: URL?
    public var handleImageSelectionURL: ((URL?) -> Void)?

    // MARK: - Emoji feedback

    public var feedbackEmojiSelectable: Bool
    public var getEmojiSelectionRating: (() -> Int)?
    public var handleEmojiSelection: ((Int) -> Void)?

    // MARK: - Init

    public init(
        contentType: ContentType?,
        options: [SharedAssessmentOptionModel]? = nil,
        optionType: OptionType? = nil,
        isSelected: @escaping (SharedAssessmentOptionModel) -> Bool,
        isReview: @escaping (SharedAssessmentOptionModel) -> Bool = { _ in false },
        isCorrectAnswer: @escaping (SharedAssessmentOptionModel) -> Bool = { _ in false },
        handleSelection: ((SharedAssessmentOptionModel) -> Void)? = nil,
        getTitle: @escaping (SharedAssessmentOptionModel) -> String,
        previousAnswer: String? = nil,
        isSubjectiveTextViewDisabled: Bool = false,
        handleSubjectiveAnswer: ((String, Bool) -> Void)? = nil,
        handleImageSelection: ((SharedAssessmentOptionModel) -> Void)? = nil,
        imageURL: URL? = nil,
        handleImageSelectionURL: ((URL?) -> Void)? = nil,
        feedbackEmojiSelectable: Bool = true,
        getEmojiSelectionRating: (() -> Int)? = nil,
        handleEmojiSelection: ((Int) -> Void)? = nil
    ) {
        self.contentType = contentType
        self.options = options
        self.optionType = optionType
        self.isSelected = isSelected
        self.isReview = isReview
        self.isCorrectAnswer = isCorrectAnswer
        self.handleSelection = handleSelection
        self.getTitle = getTitle
        self.previousAnswer = previousAnswer
        self.isSubjectiveTextViewDisabled = isSubjectiveTextViewDisabled
        self.handleSubjectiveAnswer = handleSubjectiveAnswer
        self.handleImageSelection = handleImageSelection
        self.imageURL = imageURL
        self.handleImageSelectionURL = handleImageSelectionURL
        self.feedbackEmojiSelectable = feedbackEmojiSelectable
        self.getEmojiSelectionRating = getEmojiSelectionRating
        self.handleEmojiSelection = handleEmojiSelection
    }

    // MARK: - Body

    public var body: some View {
        VStack {
            selectionContent
            Spacer()
        }
    }

    // MARK: - Routing

    @ViewBuilder
    private var selectionContent: some View {
        switch contentType {

        // ── Objective variants ──────────────────────────────────────────────
        case .some(.objective),
             .some(.textAudio),
             .some(.textVideo),
             .some(.imageText):
            if let options {
                SharedAssessmentOptionListView(
                    options: options,
                    optionType: optionType,
                    isSelected: isSelected,
                    isReview: isReview,
                    isCorrectAnswer: isCorrectAnswer,
                    handleSelection: handleSelection,
                    getTitle: getTitle
                )
            } else {
                noOptionsView
            }

        // ── Subjective ──────────────────────────────────────────────────────
        case .some(.subjective):
            SharedAssessmentSubjectiveView(
                previousAnswer: previousAnswer,
                isDisabled: isSubjectiveTextViewDisabled,
                handleAnswer: handleSubjectiveAnswer
            )
            .id(previousAnswer) // Forces TextField to reset when question changes

        // ── Image options ───────────────────────────────────────────────────
        case .some(.image):
            if let options {
                SharedAssessmentOptionAsImageView(
                    options: options,
                    handleSelection: handleImageSelection
                )
            } else {
                noOptionsView
            }

        // ── Objective + image upload ────────────────────────────────────────
        case .some(.objectiveWithImage):
            if let options {
                SharedAssessmentOptionListWithImageUploaderView(
                    options: options,
                    optionType: optionType,
                    isSelected: isSelected,
                    handleSelection: handleSelection,
                    getTitle: getTitle,
                    imageURL: imageURL,
                    handleImageSelectionURL: handleImageSelectionURL
                )
            } else {
                noOptionsView
            }

        // ── Subjective + image upload ───────────────────────────────────────
        case .some(.subjectiveWithImage):
            SharedAssessmentSubjectiveWithImageUploderView(
                previousAnswer: previousAnswer,
                handleAnswer: handleSubjectiveAnswer,
                imageURL: imageURL,
                handleImageSelectionURL: handleImageSelectionURL
            )

        // ── Emoji feedback ──────────────────────────────────────────────────
        case .some(.emoji):
            EmojiFeedbackView(
                feedbackEmojiSelectable: feedbackEmojiSelectable,
                getRatingValue: { getEmojiSelectionRating?() ?? 0 }
            ) { ratingValue in
                handleEmojiSelection?(ratingValue)
            }

        default:
            EmptyView()
        }
    }

    private var noOptionsView: some View {
        Text("No options available")
            .foregroundColor(.gray)
            .italic()
    }
}
