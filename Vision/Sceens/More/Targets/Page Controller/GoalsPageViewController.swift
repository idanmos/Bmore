//
//  GoalsPageViewController.swift
//  B-more
//
//  Created by Idan Moshe on 07/01/2021.
//

import UIKit
import AAInfographics

enum GoalsType: Int, CaseIterable {
    case day, week, month, quarter, year
    
    func configuration() -> GraphConfiguration {
        switch self {
        default:
            return GraphConfiguration(title: NSLocalizedString("day", comment: ""),
                                      subtitle: "day_subtitle",
                                      tooltip: "tooltip",
                                      categories: ["a", "b", "c"])
        }
    }
    
    func viewController(frame: CGRect) -> GraphViewController {
        let controller = GraphViewController(nibName: GraphViewController.className(), bundle: nil)
        controller.configuration = self.configuration()
        controller.destinationFrame = frame
        return controller
    }
    
    static func viewControllers(frame: CGRect) -> [GraphViewController] {
        return GoalsType.allCases.map { (obj: GoalsType) -> GraphViewController in
            let controller = obj.viewController(frame: frame)
            return controller
        }
    }
}

class GoalsPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private var graphViewControllers: [GraphViewController] = []
    
    var destinationFrame: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.graphViewControllers = GoalsType.viewControllers(frame: self.destinationFrame)
        
        self.setViewControllers([self.graphViewControllers.first!], direction: .forward, animated: true, completion: nil)
        
        self.delegate = self
        self.dataSource = self
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [GoalsPageViewController.self])
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.graphViewControllers.firstIndex(of: viewController as! GraphViewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return self.graphViewControllers.last
        }
        
        guard self.graphViewControllers.count > previousIndex else {
            return nil
        }
        
        return self.graphViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.graphViewControllers.firstIndex(of: viewController as! GraphViewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        let count = self.graphViewControllers.count

        guard count != nextIndex else {
            return nil
        }
        
        guard count > nextIndex else {
            return nil
        }
        
        return self.graphViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        self.graphViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentController: UIViewController = self.graphViewControllers.first {
            if let currentIndex = self.graphViewControllers.firstIndex(of: currentController as! GraphViewController) {
                return currentIndex
            }
        }
        return 0
    }
}
