//
//  ImagePickerProvider.swift
//  Bmore
//
//  Created by Idan Moshe on 28/01/2021.
//

import UIKit
import Photos

// MARK: - ImagePickerProviderDelegate

protocol ImagePickerProviderDelegate: class {
    var targetImageSize: CGSize { get }
    func imagePicker(_ picker: ImagePickerProvider, didFinishPicking images: Set<UIImage>)
}

// MARK: - ImagePickerProvider

class ImagePickerProvider: NSObject {
    
    private enum ImagePickerSourceType: Int {
        case camera, photoLibrary
    }
    
    var presenter: UIViewController! {
        willSet {
            guard newValue != nil else { return }
            
            if #available(iOS 14.0, *) {
                self.photoPicker.presenter = newValue
            }
        }
    }
    
    weak var delegate: ImagePickerProviderDelegate?
    
    @available(iOS 14.0, *)
    private lazy var photoPicker = PhotoPickerProvider()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        return picker
    }()
    
    init(presenter: UIViewController) {
        super.init()
        self.presenter = presenter
        
        if #available(iOS 14.0, *) {
            self.photoPicker.delegate = self
            self.photoPicker.presenter = presenter
        }
    }
    
    func showPicker(sourceType: UIImagePickerController.SourceType) {
        switch sourceType {
        case .photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
            } else {
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                    self.imagePicker.sourceType = .savedPhotosAlbum
                } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                }
            }
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
            } else {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    self.imagePicker.sourceType = .photoLibrary
                }
            }
        case .savedPhotosAlbum:
            self.imagePicker.sourceType = .savedPhotosAlbum
        @unknown default:
            self.imagePicker.sourceType = .photoLibrary
        }
        
        if sourceType == .camera {
            self.presenter.present(self.imagePicker, animated: true, completion: nil)
        } else {
            if #available(iOS 14, *) {
                self.photoPicker.presentPicker()
            } else {
                self.presenter.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
        
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ImagePickerProvider: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 1.0),
              let url = info[.imageURL] as? URL
        else {
            fatalError("###\(#function): Failed to get JPG data and URL of the picked image!")
        }
        
        self.presenter.dismiss(animated: true, completion: nil)
        
        self.delegate?.imagePicker(self, didFinishPicking: [image])
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presenter.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - PhotoPickerProviderDelegate

extension ImagePickerProvider: PhotoPickerProviderDelegate {
    
    var targetImageSize: CGSize {
        return self.delegate?.targetImageSize ?? CGSize(width: 300, height: 300)
    }
    
    @available(iOS 14, *)
    func photoPicker(_ picker: PhotoPickerProvider, didFinishPicking images: Set<UIImage>) {
        self.delegate?.imagePicker(self, didFinishPicking: images)
    }
    
}
