//
//  AddPropertyViewController.swift
//  Vision
//
//  Created by Idan Moshe on 10/12/2020.
//

import UIKit
import ImagePicker
import LocationPicker
import ContactsUI

fileprivate enum DatePickerType: Int {
    case exclusivity, enterDate
}

class AddPropertyViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// - Tag: Exclusivity
    @IBOutlet weak var exclusivityLabel: UILabel!
    @IBOutlet weak var exclusivityTextField: UITextField!
    @IBOutlet weak var exclusivitySwitch: UISwitch!
    @IBOutlet weak var exclusivityDateButton: UIButton!
    
    /// - Tag: Sale/Rent
    @IBOutlet weak var saleOrRentSegmentedControl: UISegmentedControl!
    
    /// - Tag: Type
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeButton: UIButton!
    
    /// - Tag: Address
    @IBOutlet weak var addressTextField: UITextField!
    
    /// - Tag: Size
    @IBOutlet weak var sizeTextField: UITextField!
    
    /// - Tag: Enter Date
    @IBOutlet weak var enterDateTextField: UITextField!
    @IBOutlet weak var enterNowSwitch: UISwitch!
    
    /// - Tag: Rooms
    @IBOutlet weak var roomsTextField: UITextField!
    
    /// - Tag: Balcony
    @IBOutlet weak var balconyTextField: UITextField!
    
    /// - Tag: Parking
    @IBOutlet weak var parkingTextField: UITextField!
    
    /// - Tag: Floor
    @IBOutlet weak var floorNumberTextField: UITextField!
    @IBOutlet weak var totalFloorNumberTextField: UITextField!
    
    /// - Tag: Extra Info
    @IBOutlet weak var extraInfoTextView: UITextView!
    
    /// - Tag: Price
    @IBOutlet weak var priceTextField: UITextField!
    
    /// - Tag: Contact
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var contactButton: UIButton!
    
    /// - Tag: Images
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var firstImageButton: UIButton!
    @IBOutlet weak var secondImageButton: UIButton!
    @IBOutlet weak var thirdImageButton: UIButton!
    @IBOutlet weak var forthImageButton: UIButton!
    @IBOutlet weak var fifthImageButton: UIButton!
    
    // MARK: - Variables
    
//    private lazy var datePicker: UIDatePicker = {
//        let picker = UIDatePicker()
//        picker.date = Date()
//        picker.datePickerMode = .date
//        picker.addTarget(self, action: #selector(self.OnPressDatePicker(_:)), for: .valueChanged)
//
//        if #available(iOS 13.4, *) {
//            picker.preferredDatePickerStyle = .wheels
//        }
//
//        return picker
//    }()
    
    private lazy var locationPicker: LocationPickerViewController = {
        let locationPicker = LocationPickerViewController()
        locationPicker.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeLocationController))
        locationPicker.title = "מיקום"
        locationPicker.modalPresentationStyle = .fullScreen
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        return locationPicker
    }()
    
    private lazy var cameraImage: UIImage? = {
        return UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
    }()
    
    private lazy var datePickerController: DatePickerViewController = {
        let pickerController = DatePickerViewController(nibName: DatePickerViewController.className(), bundle: nil)
        pickerController.modalPresentationStyle = .overFullScreen
        pickerController.delegate = self
        return pickerController
    }()
    
    /// - Tag: User Settings
    private var selectedAssetType: Int = 0
    private var enterDate: Date?
    private var images: [UIImage] = []
    private let propertyUUID = UUID()
    private var location: Location?
    private var contactIdentifier: String?
    private var isExclusivity: Bool = false
    private var exclusivityEndDate: Date?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    deinit {
        self.images.removeAll()
    }
    
    private func setupUI() {
        self.title = NSLocalizedString("new", comment: "")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.saveAndClose))
        
        self.priceTextField.delegate = self
        
        self.sizeTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.floorNumberTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.totalFloorNumberTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.priceTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        
        self.typeButton.layer.cornerRadius = 3
        self.typeButton.layer.borderWidth = 2
        self.typeButton.layer.borderColor = UIColor.lightGray.cgColor
        
        self.extraInfoTextView.layer.cornerRadius = 3
        self.extraInfoTextView.layer.borderWidth = 2
        self.extraInfoTextView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        
        self.addressTextField.addMapTollbar(target: self, action: #selector(self.showLocationPicker))
        
        self.exclusivityDateButton.isEnabled = false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    @objc private func showLocationPicker() {
        self.view.endEditing(true)
        
        self.locationPicker.completion = { location in
            guard let location = location else { return }
            self.location = location
            self.addressTextField.text = location.title
        }

        let navController = UINavigationController(rootViewController: self.locationPicker)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    private func showImagePicker() {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        imagePickerController.modalPresentationStyle = .fullScreen
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func showSelectCategory() {
        let miniTableView = MiniTableViewController(values: Application.AssetType.valuesLocalized(), defaultSelectedIndex: self.selectedAssetType)
        miniTableView.delegate = self
        miniTableView.modalPresentationStyle = .overFullScreen
        self.present(miniTableView, animated: true, completion: nil)
    }
    
}

// MARK: - General Methods

extension AddPropertyViewController {
    
    @objc func saveAndClose() {
        // save to core data
        var info: [Application.PropertySaveKeys: Any] = [:]
        info[.uuid] = self.propertyUUID
        info[.enterDate] = self.enterDate
        info[.type] = self.selectedAssetType
        
        if let location: Location = self.location {
            info[.latitude] = location.coordinate.latitude
            info[.longitude] = location.coordinate.longitude
        }
        
        if let address: String = self.addressTextField.text, !address.isEmpty {
            info[.address] = address
        } else {
            self.addressTextField.becomeFirstResponder()
            return
        }
        
        if let price: String = self.priceTextField.text, !price.isEmpty {
            info[.price] = price
        } else {
            self.priceTextField.becomeFirstResponder()
            return
        }
        
        info[.dateIsNow] = self.enterNowSwitch.isOn
        
        if let saleOrRent: String = self.saleOrRentSegmentedControl.titleForSegment(at: self.saleOrRentSegmentedControl.selectedSegmentIndex) {
            info[.sellOrRent] = saleOrRent
        }
        if let size: String = self.sizeTextField.text {
            info[.size] = size
        }
        if let balcony: String = self.balconyTextField.text, balcony != "0", balcony != "0.0" {
            info[.balcony] = balcony
        }
        if let parking: String = self.parkingTextField.text, parking != "0", parking != "0.0" {
            info[.parking] = parking
        }
        if let floorNumber: String = self.floorNumberTextField.text {
            info[.floorNumber] = floorNumber
        }
        if let totalFloorNumber: String = self.totalFloorNumberTextField.text {
            info[.totalFloorsNumber] = totalFloorNumber
        }
        if let extraInfo: String = self.extraInfoTextView.text {
            info[.extraInfo] = extraInfo
        }
        if let contactIdentifier: String = self.contactIdentifier {
            info[.contactIdentifier] = contactIdentifier
        }
        
        info[.isExclusivity] = self.exclusivitySwitch.isOn
        
        if let exclusiveEndDate: Date = self.exclusivityEndDate {
            info[.exclusivityEndDate] = exclusiveEndDate
        }
        
        PersistentStorage.shared.save(info)
        ImageStorage.shared.save(images: self.images, propertyId: self.propertyUUID)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension AddPropertyViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Scroll to the text field so that it is
        // not hidden by the keyboard during editing.
        guard let textFieldSuperView = textField.superview else { return }
        self.scrollView.setContentOffset(CGPoint(x: 0, y: textFieldSuperView.frame.origin.y + textField.frame.origin.y), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Remove any content offset from the scroll
        // view otherwise the scroll view will look odd.
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}

// MARK: - MiniTableViewControllerDelegate

extension AddPropertyViewController: MiniTableViewControllerDelegate {
    
    func miniTableView(_ miniTableView: MiniTableViewController, didSelectRowAt index: Int) {
        miniTableView.dismiss(animated: true, completion: nil)
        self.selectedAssetType = index
         self.typeLabel.text = Application.AssetType.allCases[index].hebrewLocalized()
    }
    
}

// MARK: - Location Picker

extension AddPropertyViewController {
    
    @objc private func closeLocationController() {
        self.locationPicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ImagePickerDelegate

extension AddPropertyViewController: ImagePickerDelegate {
        
    @objc private func onPressOnImage(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let image = button.image(for: .normal) else { return }
        
        let previewViewController = ImagePreviewViewController(image: image)
        let navController = UINavigationController(rootViewController: previewViewController)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        self.images = images
        
        self.onPressClearImagesButton(imagePicker)
        
        let numberOfImages: Int = images.count
        guard numberOfImages > 0 else { return }
        
        if numberOfImages == 1 {
            self.firstImageButton.setImage(images[0], for: .normal)
        } else if numberOfImages == 2 {
            self.firstImageButton.setImage(images[0], for: .normal)
            self.secondImageButton.setImage(images[1], for: .normal)
        } else if numberOfImages == 3 {
            self.firstImageButton.setImage(images[0], for: .normal)
            self.secondImageButton.setImage(images[1], for: .normal)
            self.thirdImageButton.setImage(images[2], for: .normal)
        } else if numberOfImages == 4 {
            self.firstImageButton.setImage(images[0], for: .normal)
            self.secondImageButton.setImage(images[1], for: .normal)
            self.thirdImageButton.setImage(images[2], for: .normal)
            self.forthImageButton.setImage(images[3], for: .normal)
        } else if numberOfImages == 5 {
            self.firstImageButton.setImage(images[0], for: .normal)
            self.secondImageButton.setImage(images[1], for: .normal)
            self.thirdImageButton.setImage(images[2], for: .normal)
            self.forthImageButton.setImage(images[3], for: .normal)
            self.fifthImageButton.setImage(images[4], for: .normal)
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - DatePickerViewControllerDelegate

extension AddPropertyViewController: DatePickerViewControllerDelegate {
    
    func pickerController(_ pickerController: DatePickerViewController, didFinishPicking date: Date) {
        pickerController.dismiss(animated: true, completion: nil)
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        
        guard let type = DatePickerType(rawValue: pickerController.view.tag) else { return }
        
        if type == .enterDate {
            self.enterDateTextField.text = dateformatter.string(from: date)
            self.enterDate = date
        } else if type == .exclusivity {
            self.exclusivityTextField.text = dateformatter.string(from: date)
            self.exclusivityEndDate = date
        }
    }
    
    func pickerControllerDidCancel(_ pickerController: DatePickerViewController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Actions

extension AddPropertyViewController {
    
    @IBAction private func onPressExlusivitySwitch(_ sender: Any) {
        guard let exlusivitySwitch = sender as? UISwitch else { return }
        self.exclusivityDateButton.isEnabled = exlusivitySwitch.isOn
        
        let isVisible: Bool = self.datePickerController.viewIfLoaded?.window != nil
        
        if exlusivitySwitch.isOn {
            if isVisible == false {
                self.onPressExlusivityDatePicker(sender)
            }
        }
    }
    
    @IBAction private func onPressExlusivityDatePicker(_ sender: Any) {
        self.datePickerController.view.tag = DatePickerType.exclusivity.rawValue
        self.present(self.datePickerController, animated: true, completion: nil)
    }
    
    @IBAction func OnPressType(_ sender: Any) {
        self.showSelectCategory()
    }
    
    @IBAction func OnPressDatePicker(_ sender: Any) {
        self.datePickerController.view.tag = DatePickerType.enterDate.rawValue
        self.present(self.datePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onPressAddContact(_ sender: Any) {
        ContactsService.shared.showContactsPicker(delegate: self, presenter: self)
    }
    
    @IBAction func onPressDeleteContact(_ sender: Any) {
        self.contactTextField.text = nil
    }
    
    @IBAction func onPressRooms(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        self.roomsTextField.text = "\(stepper.value)"
    }
    
    @IBAction func onPressBalcony(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        self.balconyTextField.text = "\(Int(stepper.value))"
    }
    
    @IBAction func onPressParking(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        self.parkingTextField.text = "\(Int(stepper.value))"
    }
    
    @IBAction func onPressDateIsNow(_ sender: Any) {
    }
    
    @IBAction func onAddImageButton(_ sender: Any) {
        self.showImagePicker()
    }
    
    @IBAction func onPressClearImagesButton(_ sender: Any) {
        self.firstImageButton.setImage(nil, for: .normal)
        self.secondImageButton.setImage(nil, for: .normal)
        self.thirdImageButton.setImage(nil, for: .normal)
        self.forthImageButton.setImage(nil, for: .normal)
        self.fifthImageButton.setImage(nil, for: .normal)
    }
    
    @IBAction func onPressFirstImageButton(_ sender: Any) {
        if let button = sender as? UIButton { button.tag = 1 }
        self.onPressOnImage(sender)
    }
    
    @IBAction func onPressSecondImageButton(_ sender: Any) {
        if let button = sender as? UIButton { button.tag = 2 }
        self.onPressOnImage(sender)
    }
    
    @IBAction func onPressThirdImageButton(_ sender: Any) {
        if let button = sender as? UIButton { button.tag = 3 }
        self.onPressOnImage(sender)
    }
    
    @IBAction func onPressForthImageButton(_ sender: Any) {
        if let button = sender as? UIButton { button.tag = 4 }
        self.onPressOnImage(sender)
    }
    
    @IBAction func onPressFifthImageButton(_ sender: Any) {
        if let button = sender as? UIButton { button.tag = 5 }
        self.onPressOnImage(sender)
    }
    
}

extension AddPropertyViewController: CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        debugPrint(#function)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        debugPrint(#function, contact)
        
        self.contactIdentifier = contact.identifier
        
        var text: String = "\(contact.givenName) \(contact.familyName)"
        if let phoneNumber: String = contact.phoneNumbers.first?.value.stringValue {
            text += ", "
            text += phoneNumber
        }
        self.contactTextField.text = text
    }
    
}
