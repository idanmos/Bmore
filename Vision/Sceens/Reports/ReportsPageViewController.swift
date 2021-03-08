//
//  ReportsPageViewController.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

class ReportsPageViewController: BasePageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private var viewModel = ReportsViewModel()
    private var chartControllers: [ChartViewController] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "reports".localized
        
        self.navigationItem.leftBarButtonItem = self.calendarBarButton
        self.navigationItem.rightBarButtonItem = self.addBarButton
        
        self.delegate = self
        self.dataSource = self
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [ReportsPageViewController.self])
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

extension ReportsPageViewController {
    
    @objc private func onPressAddButton(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(FactoryController.Screen.addTransaction.viewController, animated: true)
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

extension ReportsPageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
