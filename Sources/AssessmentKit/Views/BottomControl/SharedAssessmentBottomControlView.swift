//
//  SharedAssessmentBottomControlView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

/// Full bottom control bar for an assessment screen.
///
/// Renders (top → bottom):
/// 1. A page-dot strip **or** a `SharedAssessmentBottomSegmentControl` (when `bottomSegmentDataModel` is non-empty).
/// 2. Back / Forward chevron buttons (when `isShowNextPreviousControl` is `true`).
/// 3. A submit button on the last question.
public struct SharedAssessmentBottomControlView<ID: Hashable>: View {

    // MARK: - Properties

    public var currentQuestionIndex: Int
    public var totalQuestions: Int
    public var isFirstQuestion: Bool
    public var isLastQuestion: Bool
    public var submitButtonText: String
    public var isShowNextPreviousControl: Bool
    public var isSubmitButtonEnabled: Bool
    public var bottomSegmentDataModel: [SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<ID>]
    public var goToPreviousQuestion: () -> Void
    public var goToNextQuestion: () -> Void
    public var jumpToQuestion: ((Int) -> Void)?
    public var submitAssessment: () -> Void

    // MARK: - Init

    public init(
        currentQuestionIndex: Int,
        totalQuestions: Int,
        isFirstQuestion: Bool,
        isLastQuestion: Bool,
        submitButtonText: String = "submitEvalution".localized,
        isShowNextPreviousControl: Bool = true,
        isSubmitButtonEnabled: Bool = true,
        bottomSegmentDataModel: [SharesAssessmentBottomSegmentDataModel.SegmentDataInfoModel<ID>] = [],
        goToPreviousQuestion: @escaping () -> Void,
        goToNextQuestion: @escaping () -> Void,
        jumpToQuestion: ((Int) -> Void)? = nil,
        submitAssessment: @escaping () -> Void
    ) {
        self.currentQuestionIndex = currentQuestionIndex
        self.totalQuestions = totalQuestions
        self.isFirstQuestion = isFirstQuestion
        self.isLastQuestion = isLastQuestion
        self.submitButtonText = submitButtonText
        self.isShowNextPreviousControl = isShowNextPreviousControl
        self.isSubmitButtonEnabled = isSubmitButtonEnabled
        self.bottomSegmentDataModel = bottomSegmentDataModel
        self.goToPreviousQuestion = goToPreviousQuestion
        self.goToNextQuestion = goToNextQuestion
        self.jumpToQuestion = jumpToQuestion
        self.submitAssessment = submitAssessment
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 10) {
            segmentRow
            if isShowNextPreviousControl { backForwardButtons }
            submitRow
        }
    }

    // MARK: - Segment row

    @ViewBuilder
    private var segmentRow: some View {
        if bottomSegmentDataModel.isEmpty {
            pageDots
        } else {
            segmentControl
        }
    }

    private var pageDots: some View {
        SwiftUIUtility.CustomPageControl(
            numberOfPages: totalQuestions,
            segmentSize: 7,
            currentPage: .constant(currentQuestionIndex)
        )
    }

    private var segmentControl: some View {
        SharedAssessmentBottomSegmentControl<ID>(
            segmentDataModel: bottomSegmentDataModel,
            selectedIndex: currentQuestionIndex,
            showNavigationButtons: false,
            onSegmentChange: { index in
                jumpToQuestion?(index)
            }
        )
        .frame(height: 50)
    }

    // MARK: - Back / Forward

    private var backForwardButtons: some View {
        HStack(spacing: 20) {
            SwiftUIUtility.RectangularIconButton(
                iconName: "chevron.left",
                backgroundColor: ColorUtility.tertiaryColor
            ) {
                goToPreviousQuestion()
            }
            .disabledWithOpacityPkg(isFirstQuestion)

            SwiftUIUtility.RectangularIconButton(
                iconName: "chevron.right",
                backgroundColor: ColorUtility.tertiaryColor
            ) {
                goToNextQuestion()
            }
            .disabledWithOpacityPkg(isLastQuestion)
        }
    }

    // MARK: - Submit

    @ViewBuilder
    private var submitRow: some View {
        if isLastQuestion {
            SwiftUIUtility.RectangularIconButton(
                title: submitButtonText,
                font: .system(size: 20, weight: .semibold),
                foregroundColor: .white
            ) {
                submitAssessment()
            }
            .disabledWithOpacityPkg(!isSubmitButtonEnabled)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct SharedAssessmentBottomControlView_Previews: PreviewProvider {
    static var previews: some View {
        SharedAssessmentBottomControlView<Int32>(
            currentQuestionIndex: 0,
            totalQuestions: 10,
            isFirstQuestion: true,
            isLastQuestion: false,
            submitButtonText: "Submit",
            goToPreviousQuestion: {},
            goToNextQuestion: {},
            submitAssessment: {}
        )
        .padding()
        .previewDisplayName("Page dots — first question")

        SharedAssessmentBottomControlView<Int32>(
            currentQuestionIndex: 9,
            totalQuestions: 10,
            isFirstQuestion: false,
            isLastQuestion: true,
            submitButtonText: "Submit",
            goToPreviousQuestion: {},
            goToNextQuestion: {},
            submitAssessment: {}
        )
        .padding()
        .previewDisplayName("Page dots — last question (submit)")
    }
}
#endif
