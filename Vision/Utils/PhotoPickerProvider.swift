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
    func photoPicker(_ picker: PhotoPickerProvider, didFinishPicking images: [UIImage])
}

@available(iOS 14, *)
class PhotoPickerProvider: NSObject, PHPickerViewControllerDelegate {
    
    weak var delegate: PhotoPickerProviderDelegate?
    
    weak var presenter: UIViewController?
    
    private var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
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
        debugPrint(#function, "images: \(results.count)")
        
        self.presenter?.dismiss(animated: true)
        
        var images: [UIImage] = []
        results.forEach { (result: PHPickerResult) in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    guard let image = image as? UIImage else { return }
                    images.append(image)
                }
            } else {
                debugPrint("Unsupported item provider: \(result.itemProvider)")
            }
        }
        
        self.delegate?.photoPicker(self, didFinishPicking: images)
    }
    
}
