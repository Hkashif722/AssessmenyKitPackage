//
//  AssessmentImagePreviewView.swift
//  AssessmentKit
//
//  Changes from original:
//   • Added `public` access modifiers.
//   • Fixed naming collision: private computed property renamed to `imagePreviewContent`
//     (original had a computed property with the same name as the struct, causing
//     `body` to call itself recursively and crash).
//   • Router and NavigationService kept as-is — provided by a peer package.
//

import SwiftUI
import SwiftUIUtilities

public struct AssessmentImagePreviewView: View {
    @Environment(\.router) var router
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        imagePreviewContent
    }

    // MARK: - Private

    private var imagePreviewContent: some View {
        VStack {
            CachedAsyncImage(url: url)
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            SwiftUIUtility.RoundMenuButton(
                image: .system(name: "arrow.up.left.and.down.right.magnifyingglass"),
                buttonSize: 50,
                imagePadding: 7,
                backgroundColor: ColorUtility.secondaryColor
            ) {
                NavigationService.shared.navigate(
                    using: router,
                    to: .zoomableImageView(NavigationViewModel.ZoomableViewNavModel(url: url))
                )
            }
            .foregroundStyle(Color(.darkGray))
        }
    }
}

#if DEBUG
#Preview {
    let imgUrl = URL(string: "https://gogetempowered.com/assets/img/Thumbnail_vectors/img_thumb19.jpg")!
    return AssessmentImagePreviewView(url: imgUrl)
}
#endif
