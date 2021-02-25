//
//  UIVIewController+Permissions.swift
//  Bmore
//
//  Created by Idan Moshe on 01/02/2021.
//

import UIKit
import AVFoundation
import Photos

extension UIAlertAction {
    static func openSettingsAction(_ handler: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("OPEN_SETTINGS_BUTTON", comment: ""), style: .default) { (action: UIAlertAction) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:]) { (granted: Bool) in
                handler?()
            }
        }
    }
}

extension UIViewController {
    
    func askForCameraPermissions(_ handler: @escaping (Bool) -> Void) {
        func callback(_ granted: Bool) {
            DispatchQueue.main.async {
                handler(granted)
            }
        }
        
        if UIApplication.shared.applicationState == .background {
            debugPrint("Skipping camera permissions request when app is in background.")
            callback(false)
            return
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            debugPrint("Camera ImagePicker source not available.")
            callback(false)
            return
        }
        
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .denied {
            let alertController = UIAlertController(
                title: NSLocalizedString("MISSING_CAMERA_PERMISSION_TITLE", comment: ""),
                message: NSLocalizedString("MISSING_CAMERA_PERMISSION_MESSAGE", comment: ""),
                preferredStyle: .alert
            )
            
            let openSettingsAction = UIAlertAction.openSettingsAction {
                callback(false)
            }
            
            let dismissAction = UIAlertAction(
                title: NSLocalizedString("DISMISS_BUTTON_TEXT", comment: ""),
                style: .cancel
            ) { (action: UIAlertAction) in
                callback(false)
            }
            
            alertController.addAction(openSettingsAction)
            alertController.addAction(dismissAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else if status == .authorized {
            callback(true)
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: callback(_:))
        } else {
            debugPrint("Unknown AVAuthorizationStatus \(status.rawValue)")
        }
    }
    
    func askForMediaLibraryPermissions(_ handler: @escaping (Bool) -> Void) {
        func callback(_ granted: Bool) {
            DispatchQueue.main.async {
                handler(granted)
            }
        }
        
        func presentSettingsDialog() {
            let alertController = UIAlertController(
                title: NSLocalizedString("MISSING_MEDIA_LIBRARY_PERMISSION_TITLE", comment: ""),
                message: NSLocalizedString("MISSING_MEDIA_LIBRARY_PERMISSION_MESSAGE", comment: ""),
                preferredStyle: .alert
            )
            
            let openSettingsAction = UIAlertAction.openSettingsAction {
                callback(false)
            }
            
            let dismissAction = UIAlertAction(
                title: NSLocalizedString("DISMISS_BUTTON_TEXT", comment: ""),
                style: .cancel
            ) { (action: UIAlertAction) in
                callback(false)
            }
            
            alertController.addAction(openSettingsAction)
            alertController.addAction(dismissAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        if UIApplication.shared.applicationState == .background {
            debugPrint("Skipping media library permissions request when app is in background.")
            callback(false)
            return
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            debugPrint("PhotoLibrary ImagePicker source not available.")
            callback(false)
            return
        }
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            callback(true)
            return
        } else if status == .denied {
            presentSettingsDialog()
            return
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (newStatus: PHAuthorizationStatus) in
                if newStatus == .authorized {
                    callback(true)
                } else {
                    presentSettingsDialog()
                }
            }
            return
        } else if status == .restricted {
            debugPrint(#function, "PHAuthorizationStatusRestricted")
            return
        }
    }
    
    func askForMicrophonePermissions(_ handler: @escaping (Bool) -> Void) {
        func callback(_ granted: Bool) {
            DispatchQueue.main.async {
                handler(granted)
            }
        }
        
        if UIApplication.shared.applicationState == .background {
            debugPrint("Skipping microphone permissions request when app is in background.")
            callback(false)
            return
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission(callback(_:))
    }
    
}
