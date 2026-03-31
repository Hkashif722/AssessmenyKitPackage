//
//  ImageUploaderViewModel.swift
//  AssessmentKit
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
public final class ImageUploaderViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published public var selectedImage: UIImage?
    @Published public var fileURL: URL?
    @Published public var isImagePickerPresented = false
    @Published public var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published public var photosPickerItem: PhotosPickerItem?

    public init() {}

    // MARK: - Actions

    public func handleSelectionChange() {
        guard let selectedItem = photosPickerItem else { return }
        Task {
            do {
                guard let data = try await selectedItem.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                await MainActor.run {
                    self.selectedImage = uiImage
                    self.fileURL = self.saveImageToTemporaryFile(image: uiImage)
                }
            } catch {
                print("ImageUploaderViewModel: error loading image — \(error)")
            }
        }
    }

    public func handleImageSelection(
        _ newItem: PhotosPickerItem?,
        onImageSelected: ((UIImage, URL?) -> Void)? = nil
    ) {
        Task(priority: .userInitiated) {
            guard let newItem,
                  let data = try? await newItem.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else { return }

            let url = saveImageToTemporaryFile(image: uiImage)
            await MainActor.run {
                self.selectedImage = uiImage
                self.fileURL = url
                onImageSelected?(uiImage, url)
            }
        }
    }

    public func saveImageToTemporaryFile(image: UIImage) -> URL? {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("ImageUploaderViewModel: error saving image — \(error)")
            return nil
        }
    }
}
