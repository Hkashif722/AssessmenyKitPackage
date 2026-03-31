//
//  SharedAssessmentSubjectiveView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct SharedAssessmentSubjectiveView: View {
    public var previousAnswer: String?
    public var maxCharacters: Int
    public var isDisabled: Bool
    public var handleAnswer: ((String, Bool) -> Void)?

    @State private var subjectiveText: String = ""

    public init(
        previousAnswer: String? = nil,
        maxCharacters: Int = 500,
        isDisabled: Bool = false,
        handleAnswer: ((String, Bool) -> Void)? = nil
    ) {
        self.previousAnswer = previousAnswer
        self.maxCharacters = maxCharacters
        self.isDisabled = isDisabled
        self.handleAnswer = handleAnswer
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            SwiftUIUtility.MultilineTextInputField(
                initialText: previousAnswer ?? "",
                placeholder: "EntrTxtMsg".localized,
                maxCharacters: maxCharacters,
                isDisabled: isDisabled
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
        }
    }

    private var characterCountRow: some View {
        HStack(spacing: 10) {
            ProgressView(value: Double(subjectiveText.count) / Double(maxCharacters))
                .frame(width: 50, height: 4)
                .tint(isAtLimit ? .red : .blue)

            Text("\(subjectiveText.count) / \(maxCharacters)")
                .font(.subheadline)
                .foregroundColor(isAtLimit ? .red : .blue)
        }
    }

    private var isAtLimit: Bool { subjectiveText.count == maxCharacters }
}
