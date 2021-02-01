//
//  GoalsViewController.swift
//  B-more
//
//  Created by Idan Moshe on 07/01/2021.
//

import UIKit

class GoalsViewController: UIViewController {
    
    // MARK: - Oytlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - Variables
    
    private let viewModel = TargetsViewModel()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    
    // MARK: - Class Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = self.flowLayout
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
                
        self.navigationItem.title = NSLocalizedString("goals", comment: "") + " - " + self.viewModel.dataSource[0].title()
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//            HelpGestureViewController.show(presenter: self)
//        }
    }

}

// MARK: - Navigation

extension GoalsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? GoalsPageViewController {
            let height: CGFloat = self.containerView.frame.size.height - (self.tabBarController?.tabBar.frame.height)!
            viewController.destinationFrame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: height)
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension GoalsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCollectionViewCell.className(), for: indexPath) as! GoalCollectionViewCell
        let type = self.viewModel.dataSource[indexPath.item]
        cell.configure(type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.viewModel.dataSource[indexPath.item]
        self.navigationItem.title = NSLocalizedString("goals", comment: "") + " - " + category.title()
                
        switch category {
        case .personal:
            break
        case .financial:
            break
        case .transactions:
            break
        case .meetings:
            break
        case .score:
            break
        }
    }
    
}
