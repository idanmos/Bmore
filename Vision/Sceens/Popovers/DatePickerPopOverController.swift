//
//  DatePickerPopOverController.swift
//  B-more
//
//  Created by Idan Moshe on 12/01/2021.
//

import UIKit

class DatePickerPopOverController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var observer: ((Date) -> Void) = { arg in }
    
    var displayDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.displayDate {
            self.datePicker.date = self.displayDate!
        }
    }
    
    func observe(_ completionHandler: @escaping (Date) -> Void) {
        self.observer = completionHandler
    }
    
    @IBAction private func onDatePickerChanged(_ sender: UIDatePicker) {
        self.observer(sender.date)
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
