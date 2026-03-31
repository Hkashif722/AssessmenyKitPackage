//
//  SharedAssessmentOptionListView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct SharedAssessmentOptionListView: View {
    public var options: [SharedAssessmentOptionModel]
    public var optionType: OptionType?
    public var isSelected: (SharedAssessmentOptionModel) -> Bool
    public var isReview: (SharedAssessmentOptionModel) -> Bool
    public var isCorrectAnswer: (SharedAssessmentOptionModel) -> Bool
    public var handleSelection: ((SharedAssessmentOptionModel) -> Void)?
    public var getTitle: (SharedAssessmentOptionModel) -> String

    public init(
        options: [SharedAssessmentOptionModel],
        optionType: OptionType? = nil,
        isSelected: @escaping (SharedAssessmentOptionModel) -> Bool,
        isReview: @escaping (SharedAssessmentOptionModel) -> Bool = { _ in false },
        isCorrectAnswer: @escaping (SharedAssessmentOptionModel) -> Bool = { _ in false },
        handleSelection: ((SharedAssessmentOptionModel) -> Void)? = nil,
        getTitle: @escaping (SharedAssessmentOptionModel) -> String
    ) {
        self.options = options
        self.optionType = optionType
        self.isSelected = isSelected
        self.isReview = isReview
        self.isCorrectAnswer = isCorrectAnswer
        self.handleSelection = handleSelection
        self.getTitle = getTitle
    }

    public var body: some View {
        ScrollView {
            VStack {
                ForEach(options) { item in
                    SwiftUIUtility.SelectableListItem(
                        isSelected: isSelected(item),
                        isReview: isReview(item),
                        isCorrectAnswer: isCorrectAnswer(item),
                        title: getTitle(item),
                        selectionType: optionType
                    ) {
                        handleSelection?(item)
                    }
                }
            }
            .padding(5)
        }
    }
}
