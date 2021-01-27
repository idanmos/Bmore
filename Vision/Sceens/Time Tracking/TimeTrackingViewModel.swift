//
//  TimeTrackingViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 15/12/2020.
//

import UIKit

class TimeTrackingViewModel {
    
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    var timeTracking: [TimeTrack] = []
    
    func fetchTimeTrack() {
        self.timeTracking = AppDelegate.sharedDelegate().coreDataStack.fetchTimeTrack()
    }
    
    func showStartOrEnd(presenter: UIViewController,
                        startHandler: AlertActionHandler? = nil,
                        endHandler: AlertActionHandler? = nil) {
        let alertController = UIAlertController(title: NSLocalizedString("start_or_end", comment: ""),
                                                message: NSLocalizedString("please_choose", comment: ""),
                                                preferredStyle: .actionSheet)
        
        let startAction = UIAlertAction(title: NSLocalizedString("start", comment: ""), style: .default, handler: startHandler)
        let endAction = UIAlertAction(title: NSLocalizedString("end", comment: ""), style: .default, handler: endHandler)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(startAction)
        alertController.addAction(endAction)
        alertController.addAction(cancelAction)
        
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    func showDatePickerController(tag: Int = 0, title: String? = nil, delegate: DatePickerViewControllerDelegate? = nil, presenter: UIViewController) {
        let picker = DatePickerViewController()
        picker.view.tag = tag
        picker.modalPresentationStyle = .overFullScreen
        picker.delegate = delegate
        picker.textLabel.text = title ?? ""
        picker.datePicker.datePickerMode = .dateAndTime
        presenter.present(picker, animated: true, completion: nil)
    }
    
}
