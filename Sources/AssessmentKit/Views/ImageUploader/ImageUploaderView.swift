//
//  ImageUploaderView.swift
//  AssessmentKit
//

import SwiftUI
import PhotosUI
import SwiftUIUtilities

@available(iOS 16.0, *)
public struct ImageUploaderView: View {

    // MARK: - Properties

    public var placeholderText: String
    public var buttonText: String
    public var onImageSelected: ((UIImage, URL?) -> Void)?

    @State private var selectedImage: UIImage?
    @State private var fileURL: URL?
    @State private var selectedItem: PhotosPickerItem?
    @State private var remoteImageURL: URL?

    public init(
        _ imageURL: URL?,
        placeholderText: String = "No Image Selected",
        buttonText: String = "Choose Image",
        onImageSelected: ((UIImage, URL?) -> Void)? = nil
    ) {
        self._remoteImageURL = State(wrappedValue: imageURL)
        self.placeholderText = placeholderText
        self.buttonText = buttonText
        self.onImageSelected = onImageSelected
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 20) {
            imagePreview
            Spacer()
            uploadButton
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .cardStylePkg(
            backgroundColor: Color(.systemBackground),
            cornerRadius: 20,
            shadowColor: .gray.opacity(0.4),
            shadowRadius: 10,
            padding: 8,
            borderWidth: 1,
            borderColor: Color(.lightGray)
        )
        .onChange(of: selectedItem) { newItem in
            handleSelectionChange(newItem)
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var imagePreview: some View {
        if let image = selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        } else if let remoteURL = remoteImageURL {
            AsyncImageWithFallback(urlString: remoteURL.absoluteString, defaultImageName: "")
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 60)
                .overlay(
                    Text(placeholderText)
                        .foregroundColor(.gray)
                )
        }
    }

    private var hasImage: Bool { remoteImageURL != nil || selectedImage != nil }

    private var uploadButton: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Text(hasImage ? "Change Image" : buttonText)
                .font(.callout)
                .padding(8)
                .background(hasImage ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .foregroundColor(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(hasImage ? Color.blue : Color.gray, lineWidth: 1)
                )
        }
    }

    // MARK: - Private Helpers

    private func handleSelectionChange(_ newItem: PhotosPickerItem?) {
        remoteImageURL = nil
        Task {
            guard let newItem,
                  let data = try? await newItem.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else { return }

            selectedImage = uiImage
            fileURL = saveImageToTemporaryFile(image: uiImage)
            await MainActor.run {
                onImageSelected?(uiImage, fileURL)
            }
        }
    }

    private func saveImageToTemporaryFile(image: UIImage) -> URL? {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ImageUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            ImageUploaderView(
                URL(string: "https://content.gogetempowered.com//assets/img/Thumbnail_vectors/img_thumb89.jpg")
            ) { _, url in
                print("Selected: \(url?.absoluteString ?? "nil")")
            }
            .padding()
        }
    }
}
#endif
