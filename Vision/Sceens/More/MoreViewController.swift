//
//  MoreViewController.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

class MoreViewController: UIViewController {

    // MARK: - Oytlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - Variables
        
    private let viewModel = MoreViewModel()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    
    // MARK: - Class Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "more".localized
        
        self.collectionView.collectionViewLayout = self.flowLayout
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.showDisplay(fo: .balance)
        
        DispatchMainThreadSafe {
            self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
        
        // TODO: Fix save to defaults
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//            HelpGestureViewController.show(presenter: self)
//        }
    }

}

// MARK: - General Methods

extension MoreViewController {
    
    private func showDisplay(fo category: MoreCategory) {
        // remove all children view controllers
        self.removeAllChildren()
        
        // get appropriate view controller
        var viewController: UIViewController
        if category == .balance {
            viewController = FactoryController.Screen.AdvancedScreen.balance.viewController
        } else if category == .meetings {
            viewController = FactoryController.Screen.AdvancedScreen.meetings.viewController
        } else if category == .transactions {
            viewController = FactoryController.Screen.AdvancedScreen.transactions.viewController
        } else {
            viewController = FactoryController.Screen.AdvancedScreen.tasks.viewController
        }
        
        // set correct frame
        let height: CGFloat = self.containerView.frame.size.height - (self.tabBarController?.tabBar.frame.height)!
        let frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: height)
        viewController.view.frame = frame
                
        // add child view controller to screen
        self.add(viewController, containerView: self.containerView)
    }
    
}

// MARK: - Navigation

extension MoreViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(#file, #function, segue)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        let category: MoreCategory = self.viewModel.dataSource[indexPath.item]
        self.showDisplay(fo: category)
    }
    
}

// MARK: - Actions

extension MoreViewController {}
