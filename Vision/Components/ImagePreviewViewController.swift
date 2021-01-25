//
//  ImagePreviewViewController.swift
//  Vision
//
//  Created by Idan Moshe on 09/12/2020.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.image
        self.view = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "preview".localized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeScreen))
    }
    
}
