//
//  SelectableListItem.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

typealias SwiftUIUtility = SwiftUIUtilities.SwiftUIUtility

extension SwiftUIUtility {

    // MARK: - SelectableListItem

    struct SelectableListItem: View {
        let isSelected: Bool
        let isReview: Bool
        let isCorrectAnswer: Bool
        let title: String
        let selectionType: OptionType?
        let onSelect: () -> Void

        init(
            isSelected: Bool,
            isReview: Bool = false,
            isCorrectAnswer: Bool = false,
            title: String,
            selectionType: OptionType?,
            onSelect: @escaping () -> Void
        ) {
            self.isSelected = isSelected
            self.isReview = isReview
            self.isCorrectAnswer = isCorrectAnswer
            self.title = title
            self.selectionType = selectionType
            self.onSelect = onSelect
        }

        var body: some View {
            HStack {
                checkListView
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(alignment: .topTrailing) {
                yourAnswerView
            }
            .onTapGesture {
                onSelect()
            }
        }

        @ViewBuilder
        private var checkListView: some View {
            switch isReview {
            case true where isCorrectAnswer == true:
                CheckListStatus(isSelected: isSelected, selectionType: selectionType)

            case true where isCorrectAnswer == false && isSelected == true:
                CheckListStatus(
                    isSelected: isSelected,
                    selectedImageName: "xmark.circle.fill",
                    selectedIconColor: ColorUtility.deepRed,
                    selectionType: selectionType
                )

            case true where isCorrectAnswer == false && isSelected == false:
                Spacer().frame(width: 30)

            default:
                CheckListStatus(isSelected: isSelected, selectionType: selectionType)
            }
        }

        @ViewBuilder
        private var yourAnswerView: some View {
            if isReview && isSelected {
                YouAnswerTextView()
            }
        }

        private var backgroundColor: Color {
            switch isReview {
            case true where isCorrectAnswer == true:
                return ColorUtility.mintGreen
            case true where isCorrectAnswer == false && isSelected == true:
                return ColorUtility.deepRed.opacity(0.3)
            default:
                return Color(.systemGray6)
            }
        }
    }

    // MARK: - YouAnswerTextView

    struct YouAnswerTextView: View {
        var body: some View {
            Text("Your Answer")
                .font(.caption)
                .padding(.init(top: 2, leading: 10, bottom: 2, trailing: 10))
                .background(Color(.gray).opacity(0.3))
                .cornerRadiusPkg(10, corners: [.topRight, .bottomLeft])
        }
    }

    // MARK: - CheckListStatus

    struct CheckListStatus: View {
        let isSelected: Bool
        let selectedImageName: String
        let selectedIconColor: Color
        let selectionType: OptionType?

        init(
            isSelected: Bool,
            selectedImageName: String = "checkmark.circle.fill",
            selectedIconColor: Color = .green,
            selectionType: OptionType?
        ) {
            self.isSelected = isSelected
            self.selectedImageName = selectedImageName
            self.selectedIconColor = selectedIconColor
            self.selectionType = selectionType
        }

        var body: some View {
            Group {
                switch selectionType {
                case .some(.singleSelection):
                    if isSelected {
                        Image(systemName: selectedImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(selectedIconColor)
                    } else {
                        Circle()
                            .stroke(Color.gray, lineWidth: 1.0)
                            .frame(width: 20, height: 20)
                    }

                case .some(.multipleSelection):
                    if isSelected {
                        Image(systemName: "checkmark.square.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.green)
                    } else {
                        Rectangle()
                            .stroke(Color.gray, lineWidth: 1.0)
                            .frame(width: 16, height: 16)
                    }

                default:
                    EmptyView()
                }
            }
            .padding(.trailing, 5)
        }
    }
}
