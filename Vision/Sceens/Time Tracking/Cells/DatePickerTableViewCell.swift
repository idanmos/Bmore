//
//  DatePickerTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 16/12/2020.
//

import UIKit

protocol DatePickerTableViewCellDelegate: class {
    func pickerCell(_ pickerCell: DatePickerTableViewCell, didChange date: Date)
}

class DatePickerTableViewCell: UITableViewCell {
    
    weak var delegate: DatePickerTableViewCellDelegate?
    
    @IBOutlet weak var datePickerTitleLabel: UILabel!
    @IBOutlet weak var datePickerValueLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func toggle() {
        let animationOption: UIView.AnimationOptions = self.datePicker.isHidden ? .transitionCurlDown : .transitionCurlUp
        
        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0.1, options: animationOption) { [weak self] in
            guard let self = self else { return }
            self.datePicker.isHidden.toggle()
            self.datePickerValueLabel.textColor = self.datePicker.isHidden ? .secondaryLabel : self.tintColor
        } completion: { (finished) in
            //
        }
        
//        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0.1, options: .showHideTransitionViews) { [weak self] in
//            guard let self = self else { return }
//            self.datePicker.isHidden.toggle()
//            self.datePickerValueLabel.textColor = self.datePicker.isHidden ? .secondaryLabel : self.tintColor
//        } completion: { (finished) in
            //
//        }

        
//        UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
//            guard let self = self else { return }
//            self.datePicker.isHidden.toggle()
//            self.datePickerValueLabel.textColor = self.datePicker.isHidden ? .secondaryLabel : self.tintColor
//        }
    }
    
    func collapse() {
        self.datePicker.isHidden = true
        self.datePickerValueLabel.textColor = .secondaryLabel
    }
    
    @IBAction private func onDatePickerValueChange(_ sender: UIDatePicker) {
        self.delegate?.pickerCell(self, didChange: sender.date)
    }
    
}
