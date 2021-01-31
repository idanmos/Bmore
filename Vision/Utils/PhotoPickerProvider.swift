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
        PHPhotoLibrary.requestAuthorization { [weak self] (authStatus: PHAuthorizationStatus) in
            guard let self = self else { return }
            
            DispatchMainThreadSafe {
                if authStatus == .authorized || authStatus == .limited {
                    self.picker.delegate = self
                    self.presenter?.present(self.picker, animated: true)
                }
            }
        }
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.presenter?.dismiss(animated: true)
        
        var images: Set<UIImage> = []

        for result: PHPickerResult in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        images.insert(image)
                        
                        if images.count == results.count {
                            // finished
                            DispatchMainThreadSafe {
                                self.delegate?.photoPicker(self, didFinishPicking: images)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
