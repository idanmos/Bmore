//
//  DatePickerViewController.swift
//  Vision
//
//  Created by Idan Moshe on 10/12/2020.
//

import UIKit

protocol DatePickerViewControllerDelegate: class {
    func pickerController(_ pickerController: DatePickerViewController, didFinishPicking date: Date)
    func pickerControllerDidCancel(_ pickerController: DatePickerViewController)
}

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textLabel: UILabel!
    
    weak var delegate: DatePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.delegate?.pickerControllerDidCancel(self)
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.delegate?.pickerController(self, didFinishPicking: self.datePicker.date)
    }
    
}
