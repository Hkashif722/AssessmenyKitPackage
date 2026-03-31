//
//  SharedAssessmentOptionListWithImageUploaderView.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

public struct SharedAssessmentOptionListWithImageUploaderView: View {
    public var options: [SharedAssessmentOptionModel]
    public var optionType: OptionType?
    public var isSelected: (SharedAssessmentOptionModel) -> Bool
    public var handleSelection: ((SharedAssessmentOptionModel) -> Void)?
    public var getTitle: (SharedAssessmentOptionModel) -> String
    public var imageURL: URL?
    public var handleImageSelectionURL: ((URL?) -> Void)?

    public init(
        options: [SharedAssessmentOptionModel],
        optionType: OptionType? = nil,
        isSelected: @escaping (SharedAssessmentOptionModel) -> Bool,
        handleSelection: ((SharedAssessmentOptionModel) -> Void)? = nil,
        getTitle: @escaping (SharedAssessmentOptionModel) -> String,
        imageURL: URL? = nil,
        handleImageSelectionURL: ((URL?) -> Void)? = nil
    ) {
        self.options = options
        self.optionType = optionType
        self.isSelected = isSelected
        self.handleSelection = handleSelection
        self.getTitle = getTitle
        self.imageURL = imageURL
        self.handleImageSelectionURL = handleImageSelectionURL
    }

    public var body: some View {
        ScrollView {
            VStack {
                ForEach(options) { item in
                    SwiftUIUtility.SelectableListItem(
                        isSelected: isSelected(item),
                        title: getTitle(item),
                        selectionType: optionType
                    ) {
                        handleSelection?(item)
                    }
                }

                imageUploaderView
            }
            .padding(5)
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
}
