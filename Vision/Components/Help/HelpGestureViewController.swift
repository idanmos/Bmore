//
//  HelpGestureViewController.swift
//  B-more
//
//  Created by Idan Moshe on 08/01/2021.
//

import UIKit

class HelpGestureViewController: UIViewController {
    
    class func show(presenter: UIViewController) {
        let viewController = HelpGestureViewController(nibName: HelpGestureViewController.className(), bundle: nil)
        viewController.modalPresentationStyle = .overFullScreen
        presenter.present(viewController, animated: true, completion: nil)
    }
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        self.titleLabel.textColor = .white
        self.view.bringSubviewToFront(self.closeButton)
    }
    
    @IBAction private func closeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
