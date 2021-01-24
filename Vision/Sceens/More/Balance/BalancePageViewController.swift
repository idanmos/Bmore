//
//  BalancePageViewController.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

class BalancePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    class func build() -> BalancePageViewController {
        let viewController = BalancePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return viewController
    }
    
    private var viewModel = BalanceViewModel()
    private var chartControllers: [ChartViewController] = []
    private var advancedViewController: MoreViewController?
    
    private lazy var addBarButton: UIBarButtonItem = {
        let control = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPressAddButton(_:)))
        return control
    }()
    
    private lazy var calendarBarButton: UIBarButtonItem = {
        let control = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(self.onPressCalendarButton(_:)))
        return control
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if let advancedController = parent as? MoreViewController {
            if Application.isHebrew() {
                advancedController.navigationItem.leftBarButtonItem = self.addBarButton
                advancedController.navigationItem.rightBarButtonItem = self.calendarBarButton
            } else {
                advancedController.navigationItem.leftBarButtonItem = self.calendarBarButton
                advancedController.navigationItem.rightBarButtonItem = self.addBarButton
            }
            
            self.advancedViewController = advancedController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [BalancePageViewController.self])
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        
        self.viewModel.presenter = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadCharts()
    }
    
    private func reloadCharts() {
        self.chartControllers.removeAll()
        
        BalanceType.allCases.forEach { (obj: BalanceType) in
            let configuration: GraphConfiguration = self.viewModel.getConfiguration(for: obj)
            let viewController = ChartViewController.build(frame: self.view.frame, configuration: configuration)
            self.chartControllers.append(viewController)
        }
        
        self.setViewControllers([self.chartControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.chartControllers.firstIndex(of: viewController as! ChartViewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return self.chartControllers.last
        }
        
        guard self.chartControllers.count > previousIndex else {
            return nil
        }
        
        return self.chartControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.chartControllers.firstIndex(of: viewController as! ChartViewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        let count = self.chartControllers.count

        guard count != nextIndex else {
            return nil
        }
        
        guard count > nextIndex else {
            return nil
        }
        
        return self.chartControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        self.chartControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentController: UIViewController = self.chartControllers.first {
            if let currentIndex = self.chartControllers.firstIndex(of: currentController as! ChartViewController) {
                return currentIndex
            }
        }
        return 0
    }

}

// MARK: - Actions

extension BalancePageViewController {
    
    @objc private func onPressAddButton(_ sender: UIBarButtonItem) {
        guard let advancedController: MoreViewController = self.advancedViewController else { return }
        guard let storyboard: UIStoryboard = advancedController.storyboard else { return }

        guard let addTransactionController = storyboard.instantiateViewController(withIdentifier: AddTransactionTableViewController.className())
                as? AddTransactionTableViewController
        else { return }

        advancedController.navigationController?.pushViewController(addTransactionController, animated: true)
    }
    
    @objc private func onPressCalendarButton(_ sender: UIBarButtonItem) {
        guard let popVC = UIStoryboard(name: "Popovers", bundle: nil).instantiateViewController(withIdentifier: DatePickerPopOverController.className())
                as? DatePickerPopOverController
        else { return }
        
        popVC.displayDate = self.viewModel.getDisplayDate()
        
        popVC.observe { [weak self] (date: Date) in
            guard let self = self else { return }
            self.viewModel.load(date: date)
            self.reloadCharts()
        }
        
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.barButtonItem = sender
        popOverVC?.delegate = self
//        popOverVC?.sourceView = (sender as! UIView)
//        popOverVC?.sourceRect = CGRect(x: (sender as! UIView).bounds.midX, y: (sender as! UIView).bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 314, height: 220)
        self.present(popVC, animated: true)
    }
    
}

extension BalancePageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
