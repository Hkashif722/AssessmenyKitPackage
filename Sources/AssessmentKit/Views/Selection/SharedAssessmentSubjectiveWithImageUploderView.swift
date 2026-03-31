//
//  SharedAssessmentSubjectiveWithImageUploderView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct SharedAssessmentSubjectiveWithImageUploderView: View {
    public var previousAnswer: String?
    public var maxCharacters: Int
    public var handleAnswer: ((String, Bool) -> Void)?
    public var imageURL: URL?
    public var handleImageSelectionURL: ((URL?) -> Void)?

    @State private var subjectiveText: String = ""

    public init(
        previousAnswer: String? = nil,
        maxCharacters: Int = 250,
        handleAnswer: ((String, Bool) -> Void)? = nil,
        imageURL: URL? = nil,
        handleImageSelectionURL: ((URL?) -> Void)? = nil
    ) {
        self.previousAnswer = previousAnswer
        self.maxCharacters = maxCharacters
        self.handleAnswer = handleAnswer
        self.imageURL = imageURL
        self.handleImageSelectionURL = handleImageSelectionURL
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            SwiftUIUtility.MultilineTextInputField(
                initialText: previousAnswer ?? "",
                placeholder: "EntrTxtMsg".localized,
                maxCharacters: maxCharacters
            ) { updatedText, isDebounce in
                subjectiveText = updatedText
                handleAnswer?(updatedText, isDebounce)
            }
            .onAppear {
                if let previousAnswer {
                    subjectiveText = String(previousAnswer.prefix(maxCharacters))
                }
            }

            characterCountRow
            imageUploaderView
        }
    }

    // MARK: - Private Subviews

    private var characterCountRow: some View {
        HStack(spacing: 10) {
            ProgressView(value: Double(subjectiveText.count) / Double(maxCharacters))
                .frame(width: 50, height: 4)
                .tint(isAtLimit ? .red : .blue)

            Text("\(subjectiveText.count) / \(maxCharacters) characters")
                .font(.subheadline)
                .foregroundColor(isAtLimit ? .red : .blue)
        }
    }

    @ViewBuilder
    private var imageUploaderView: some View {
        if #available(iOS 16.0, *) {
            ImageUploaderView(imageURL) { _, url in
                handleImageSelectionURL?(url)
            }
        }
    }

    private var isAtLimit: Bool { subjectiveText.count == maxCharacters }
}
