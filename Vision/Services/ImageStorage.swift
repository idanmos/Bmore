//
//  ImageStorage.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import UIKit

class ImageStorage {
    
    static let shared = ImageStorage()
    
    private func documentsDirectory() -> String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    private func documentsDirectoryURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private func buildURL(propertyId: UUID) -> URL? {
        guard var baseURL: URL = self.documentsDirectoryURL() else { return nil }
        baseURL.appendPathComponent("images/\(propertyId.uuidString)")
        return baseURL
    }
    
    func save(images: [UIImage], propertyId: UUID) {
        guard images.count > 0 else { return }
        
        guard var baseURL: URL = self.documentsDirectoryURL() else { return }
        baseURL.appendPathComponent("images/\(propertyId.uuidString)")
        
        do {
            try FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true, attributes: nil)
            debugPrint(#file, #function, "directiry created at: \(baseURL)")
        } catch let error {
            debugPrint(#file, #function, error)
        }
        
        for (index, image) in images.enumerated() {
            let fileURL = baseURL.appendingPathComponent("\(index).png")
            
            do {
                try image.pngData()?.write(to: fileURL, options: .atomic)
                debugPrint(#file, #function, "file saved to: \(fileURL)")
            } catch let error {
                debugPrint(#file, #function, error)
            }
        }
    }
    
    func load(propertyId: UUID) -> [UIImage] {
        guard let baseURL = self.buildURL(propertyId: propertyId) else { return [] }
        guard baseURL.filestatus == .directory else { return [] }
        
        var filePaths: [String] = []
        do {
            filePaths = try FileManager.default.contentsOfDirectory(atPath: baseURL.path)
        } catch let error {
            debugPrint(#file, #function, error)
        }
        
        var images: [UIImage] = []
        for fileName: String in filePaths {
            let fileURL = baseURL.appendingPathComponent(fileName)
            if let image = UIImage(contentsOfFile: fileURL.path) {
                images.append(image)
            }
        }
        
        return images
    }
    
    func loadFirstImage(propertyId: UUID?) -> UIImage? {
        guard let propertyId = propertyId else { return nil }
        guard let baseURL = self.buildURL(propertyId: propertyId) else { return nil }
        guard baseURL.filestatus == .directory else { return nil }
        
        let fileURL = baseURL.appendingPathComponent("0.png")
        if let image = UIImage(contentsOfFile: fileURL.path) {
            return image
        } else {
            return nil
        }
    }
    
    func delete(propertyId: UUID?) {
        guard let propertyId = propertyId else { return }
        guard let baseURL = self.buildURL(propertyId: propertyId) else { return }
        guard baseURL.filestatus == .directory else { return }
        
        do {
            try FileManager.default.removeItem(at: baseURL)
            debugPrint(#file, #function, "Folder delete successfully")
        } catch let error {
            debugPrint(#file, #function, error)
        }
    }
    
}
