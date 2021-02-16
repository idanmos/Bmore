//
//  DocumentsViewModel.swift
//  Bmore
//
//  Created by Idan Moshe on 15/02/2021.
//

import UIKit

extension URL {
    
    static var deviceDocumentDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static var appDocumentDirectory: URL = deviceDocumentDirectory.appendingPathComponent(DocumentsViewModel.folderPathComponent)
    
    var modificationDate: Date? {
        get {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: self.path)
                return attr[FileAttributeKey.modificationDate] as? Date
            } catch {
                return nil
            }
        }
    }
    
    var size: NSNumber? {
        get {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: self.path)
                return attr[FileAttributeKey.size] as? NSNumber
            } catch {
                return nil
            }
        }
    }
    
}

class DocumentsViewModel {
    
    static let folderPathComponent: String = "documents"
    
    var files: [File] = []
    
    init() {
        do {
            try FileManager.default.createDirectory(at: .appDocumentDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            debugPrint(#file, #function, error)
        }
    }
    
    func fetchFiles(_ handler: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var urls: [URL] = []
            
            do {
                urls = try FileManager.default.contentsOfDirectory(at: .appDocumentDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            } catch {
                debugPrint(#file, #function, error)
            }
            
            debugPrint(#file, #function, "urls", urls)
            
            self.files = urls.map({ File(url: $0) })
            
            DispatchMainThreadSafe { handler() }
        }
    }
    
    func save(files: [URL], _ handler: @escaping () -> Void) {
        let lock = NSLock()
        lock.lock()
        
        DispatchQueue.global(qos: .background).async {
            for file: URL in files {
                let newURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent(DocumentsViewModel.folderPathComponent)
                    .appendingPathComponent(file.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: newURL.path) { continue }
                
                do {
                    try FileManager.default.copyItem(at: file, to: newURL)
                } catch {
                    debugPrint(#file, #function, error)
                }
                
                DispatchMainThreadSafe { handler() }
                
                lock.unlock()
            }
        }
    }
    
}
