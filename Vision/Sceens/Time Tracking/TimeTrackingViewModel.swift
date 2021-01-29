//
//  TimeTrackingViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 15/12/2020.
//

import UIKit
import CoreData

class TimeTrackingViewModel: BaseViewModel {
    
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    var timeTracking: [TimeTrack] = []
    
    func fetchTimeTrack() {
        self.timeTracking = TimeTrackingViewModel.fetchTimeTrack()
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

// MARK: - Time Tracking

extension TimeTrackingViewModel {
    
    class func fetchTimeTrack(fetchLimit: Int? = nil) -> [TimeTrack] {
        let request: NSFetchRequest<TimeTrack> = TimeTrack.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
                
        do {
            let results: [TimeTrack] = try TimeTrackingViewModel.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
}
