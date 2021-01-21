//
//  GalleryViewController.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit

class GalleryViewController: UIPageViewController {
    
    var images: [UIImage] = [] {
        didSet {
            self.populateItems()
            
            if let firstViewController = self.items.first {
                self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private var items: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.setupPageControl()
    }
    
    private func setupPageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [GalleryViewController.self])
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
    }
    
    private func populateItems() {
        for image in self.images {
            let viewController = self.createItemController(with: image, frame: self.view.frame)
            self.items.append(viewController)
        }
    }
    
    private func createItemController(with image: UIImage, frame: CGRect = .zero) -> UIViewController {
        let viewController = UIViewController()
        viewController.view = UIImageView(image: image)
        viewController.view.frame = frame
        return viewController
    }

}

// MARK: - DataSource

extension GalleryViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return self.items.last
        }
        
        guard self.items.count > previousIndex else {
            return nil
        }
        
        return self.items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard self.items.count != nextIndex else {
            return self.items.first
        }
        
        guard self.items.count > nextIndex else {
            return nil
        }
        
        return self.items[nextIndex]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return self.items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = self.items.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}
