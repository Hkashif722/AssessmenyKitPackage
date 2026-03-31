//
//  ImageOptionCard.swift
//  AssessmentKit
//

import SwiftUI
import SwiftUIUtilities

struct ImageOptionCard<Option: AssessmentOptionProtocol> {
    let option: Option
    let isGrid: Bool
    let onImageTap: () -> Void
    let onOptionTap: () -> Void
}

extension ImageOptionCard: View {

    var body: some View {
        imageOptionCardView
            .frame(maxWidth: .infinity)
            .cardStylePkg(
                backgroundColor: backgroundColor,
                cornerRadius: 15,
                shadowColor: .gray.opacity(0.3),
                shadowRadius: 5,
                padding: 8
            )
            .overlay(alignment: .topTrailing) {
                yourAnswerView
            }
    }

    // MARK: - Layout

    @ViewBuilder
    private var imageOptionCardView: some View {
        if isGrid {
            VStack { imageOptionCard }
        } else {
            HStack { imageOptionCard }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var imageOptionCard: some View {
        Group {
            imageView
            optionTextCheckMarkView
        }
    }

    // MARK: - Checkmark row

    private var optionTextCheckMarkView: some View {
        HStack {
            Spacer()
            checkListView
        }
        .contentShape(Rectangle())
        .onTapGesture { onOptionTap() }
    }

    @ViewBuilder
    private var checkListView: some View {
        switch option.isReview {
        case true where option.isCorrectAnswer == true:
            SwiftUIUtility.CheckListStatus(isSelected: true, selectionType: .singleSelection)

        case true where option.isCorrectAnswer == false && option.isSelected == true:
            SwiftUIUtility.CheckListStatus(
                isSelected: true,
                selectedImageName: "xmark.circle.fill",
                selectedIconColor: ColorUtility.deepRed,
                selectionType: .singleSelection
            )

        case true where option.isCorrectAnswer == false && option.isSelected == false:
            Spacer().frame(width: 30)

        default:
            SwiftUIUtility.CheckListStatus(
                isSelected: option.isSelected,
                selectionType: .singleSelection
            )
        }
    }

    // MARK: - Image

    @ViewBuilder
    private var imageView: some View {
        if isGrid {
            gridImageView
        } else {
            HStack { listImageView }
        }
    }

    private var gridImageView: some View {
        AsyncImageWithFallback(urlString: option.imagePath?.absoluteString, defaultImageName: "")
            .aspectRatio(1.3, contentMode: .fill)
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture { onImageTap() }
    }

    private var listImageView: some View {
        AsyncImageWithFallback(urlString: option.imagePath?.absoluteString, defaultImageName: "")
            .frame(width: 130, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture { onImageTap() }
    }

    // MARK: - Your Answer badge

    @ViewBuilder
    private var yourAnswerView: some View {
        if option.isReview && option.isSelected {
            SwiftUIUtility.YouAnswerTextView()
        }
    }

    // MARK: - Background

    private var backgroundColor: Color {
        switch option.isReview {
        case true where option.isCorrectAnswer == true:
            return ColorUtility.mintGreen
        case true where option.isCorrectAnswer == false && option.isSelected == true:
            return ColorUtility.deepRed.opacity(0.3)
        default:
            return Color(.systemBackground)
        }
    }
}

// MARK: - Preview

#Preview {
    let option = OptionModel(
        title: "Option 1",
        isSelected: false,
        optionText: "Option 1",
        isCorrectAnswer: true
    )
    return ImageOptionCard(
        option: option,
        isGrid: true,
        onImageTap: { print("Image tapped") },
        onOptionTap: { print("Option tapped") }
    )
    .padding()
}
