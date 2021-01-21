//
//  LeadContactTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 17/01/2021.
//

import UIKit

class LeadContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var makePhoneCallButton: UIButton!
    
    @IBOutlet var leadContactButtons: [UIButton]!
    
    var deviceContact: DeviceContact? {
        willSet {
            if let _ = newValue {
                self.sendEmailButton.isEnabled = true
                self.sendMessageButton.isEnabled = true
                self.makePhoneCallButton.isEnabled = true
            } else {
                self.sendEmailButton.isEnabled = false
                self.sendMessageButton.isEnabled = false
                self.makePhoneCallButton.isEnabled = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.leadContactButtons.forEach { (obj: UIButton) in
            obj.makeAsCircle()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPressSendEmail(_ sender: Any) {
        guard let contact = self.deviceContact else { return }
        guard let topMostController: UIViewController = UIApplication.shared.topMostController() else { return }
        
        topMostController.sendEmail(email: contact.emailAddresses.first ?? "")
    }
    
    @IBAction func onPressSendMessage(_ sender: Any) {
        guard let contact = self.deviceContact else { return }
        guard let topMostController: UIViewController = UIApplication.shared.topMostController() else { return }
        
        topMostController.sendSMS(phoneNumber: contact.phoneNumbers.first ?? "")
    }
    
    @IBAction func onPressMakePhoneCall(_ sender: Any) {
        guard let contact = self.deviceContact else { return }
        guard contact.phoneNumbers.count > 0 else { return }
        guard let number = URL(string: "tel://" + contact.phoneNumbers[0]) else { return }
        
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
}
