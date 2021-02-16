//
//  DocumentPreview.swift
//  Bmore
//
//  Created by Idan Moshe on 15/02/2021.
//

import UIKit
import QuickLook

protocol DocumentPreviewDelegate: class {
    var presenter: UIViewController { get }
    func documentPreview(_ preview: DocumentPreview, transitionViewFor file: File?) -> UIView?
    func documentPreview(_ preview: DocumentPreview, didUpdateContentsOf previewFile: File?)
}

class DocumentPreview: NSObject {
    
    private var file: File?
    
    weak var delegate: DocumentPreviewDelegate?
    
    func openDocument(_ url: URL) {
        let viewController = QLPreviewController()
        viewController.dataSource = self
        viewController.delegate = self
        self.file = File(url: url)
//        viewController.currentPreviewItemIndex = currentPreviewItemIndex
        self.delegate?.presenter.present(viewController, animated: true, completion: nil)
    }
    
}

// MARK: - QLPreviewControllerDataSource

extension DocumentPreview: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1//self.files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.file!//self.files[index]
    }
    
}

// MARK: - QLPreviewControllerDelegate

extension DocumentPreview: QLPreviewControllerDelegate {
    
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        return self.delegate?.documentPreview(self, transitionViewFor: item as? File) // cell.tumbnailImageView
    }
    
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        return .updateContents
    }
    
    func previewController(_ controller: QLPreviewController, didUpdateContentsOf previewItem: QLPreviewItem) {
        DispatchMainThreadSafe {
            self.delegate?.documentPreview(self, didUpdateContentsOf: previewItem as? File)
        }
    }
    
}
