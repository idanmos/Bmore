//
//  PhotoPickerProvider.swift
//  Bmore
//
//  Created by Idan Moshe on 29/01/2021.
//

import UIKit
import PhotosUI

@available(iOS 14, *)
protocol PhotoPickerProviderDelegate: class {
    var targetImageSize: CGSize { get }
    func photoPicker(_ picker: PhotoPickerProvider, didFinishPicking images: Set<UIImage>)
}

@available(iOS 14, *)
class PhotoPickerProvider: NSObject, PHPickerViewControllerDelegate {
    
    weak var delegate: PhotoPickerProviderDelegate?
    
    weak var presenter: UIViewController?
    
    private var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    
    func presentPicker() {
        self.picker.delegate = self
        self.presenter?.present(self.picker, animated: true)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.presenter?.dismiss(animated: true)
        
        let size = self.delegate?.targetImageSize ?? CGSize(width: 300, height: 300)
        results.getImages(size: size) { (images: Set<UIImage>) in
            DispatchMainThreadSafe {
                self.delegate?.photoPicker(self, didFinishPicking: images)
            }
        }
    }
    
}

@available(iOS 14, *)
extension Array where Element == PHPickerResult {
    
    func getImages(size: CGSize, handler: @escaping (Set<UIImage>) -> Void) {
        var images: Set<UIImage> = []
        defer { handler(images) }
        guard self.count > 0 else { return }
        
        let identifiers: [String] = self.compactMap(\.assetIdentifier)
        let fetchResults: PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                
        fetchResults.enumerateObjects { (asset: PHAsset, index: Int, stop) in
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (image: UIImage?, info: [AnyHashable : Any]?) in
                if let image: UIImage = image {
                    images.insert(image)
                }
            }
        }
    }
    
}
