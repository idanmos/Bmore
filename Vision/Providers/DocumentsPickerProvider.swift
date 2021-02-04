//
//  DocumentsPickerProvider.swift
//  Bmore
//
//  Created by Idan Moshe on 03/02/2021.
//

import UIKit
import MobileCoreServices

class DocumentsPickerProvider: NSObject {
    
    func openDocumentPicker(presenter: UIViewController) {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [], in: .import)
        documentPickerController.delegate = self
        documentPickerController.modalPresentationStyle = .formSheet
        presenter.present(documentPickerController, animated: true, completion: nil)
    }
    
}

extension DocumentsPickerProvider: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("URL= \(url)")
    }
    
}
