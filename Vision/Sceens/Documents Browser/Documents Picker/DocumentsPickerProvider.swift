//
//  DocumentsPickerProvider.swift
//  Bmore
//
//  Created by Idan Moshe on 03/02/2021.
//

import UIKit
import MobileCoreServices

protocol DocumentsPickerDelegate: class {
    func documentsPicker(_ picker: DocumentsPickerProvider, didPickDocumentsAt urls: [URL])
    func documentsPickerWasCancelled(_ picker: DocumentsPickerProvider)
}

class DocumentsPickerProvider: NSObject {
    
    weak var delegate: DocumentsPickerDelegate?
    
    private let documentTypes: [String] = [
        kUTTypePDF as String,
        kUTTypeRTF as String,
        kUTTypeData as String,
        kUTTypeXML as String,
        kUTTypeJSON as String,
        kUTTypeLog as String,
        kUTTypeSpreadsheet as String,
        kUTTypeText as String
    ]
    
    func importDocumentPicker(presenter: UIViewController) {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: self.documentTypes, in: .import)
        documentPickerController.delegate = self
        documentPickerController.modalPresentationStyle = .formSheet
        presenter.present(documentPickerController, animated: true, completion: nil)
    }
    
}

extension DocumentsPickerProvider: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        debugPrint(#file, #function, urls)
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.documentsPicker(self, didPickDocumentsAt: urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        debugPrint(#file, #function)
        controller.dismiss(animated: true, completion: nil)
    }
    
}
