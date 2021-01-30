//
//  ImagePreviewViewController.swift
//  Vision
//
//  Created by Idan Moshe on 09/12/2020.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "preview".localized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.closeScreen)
        )
        
        self.imageView.image = self.image
    }
    
}
