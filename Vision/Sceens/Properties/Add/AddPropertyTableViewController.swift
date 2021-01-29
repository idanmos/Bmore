//
//  AddPropertyTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 10/12/2020.
//

import UIKit
import ImagePicker
import LocationPicker

fileprivate enum DatePickerType: Int {
    case exclusivity, enterDate
}

class AddPropertyTableViewController: BaseTableViewController {
    
    private enum Constants {
        static let defaultCellHeight: CGFloat = 43.5
        static let pickerCellExpandedHeight: CGFloat = 216.0
        static let pickerCellCollapsedHeight: CGFloat = 0.0
        static let moreInfoCellHeight: CGFloat = 155.0
        static let photosCellHeight: CGFloat = 70.0
    }
    
    private enum SectionType: Int, CaseIterable {
        case types = 0
        case entryImmediatly = 1
        case entryDate = 2
        case exclusivityDate = 3
        case address = 4
        case sizeAndFloor = 5
        case roomsBalconyParking = 6
        case extraInfo = 7
        case price = 8
        case photos = 9
        
        func numberOfRows() -> Int {
            switch self {
            case .types: return 2
            case .entryImmediatly: return 1
            case .entryDate: return 2
            case .exclusivityDate: return 2
            case .address: return 1
            case .sizeAndFloor: return 2
            case .roomsBalconyParking: return 3
            case .extraInfo: return 1
            case .price: return 1
            case .photos: return 2
            }
        }
        
        func height(isExpanded: Bool, indexPath: IndexPath) -> CGFloat {
            switch self {
            case .types: return Constants.defaultCellHeight
            case .entryImmediatly: return Constants.defaultCellHeight
            case .entryDate: return isExpanded ? Constants.pickerCellExpandedHeight : Constants.pickerCellCollapsedHeight
            case .exclusivityDate: return isExpanded ? Constants.pickerCellExpandedHeight : Constants.pickerCellCollapsedHeight
            case .address: return Constants.defaultCellHeight
            case .sizeAndFloor: return Constants.defaultCellHeight
            case .roomsBalconyParking: return Constants.defaultCellHeight
            case .extraInfo: return Constants.moreInfoCellHeight
            case .price: return Constants.defaultCellHeight
            case .photos: return indexPath.item == 0 ? Constants.defaultCellHeight : Constants.photosCellHeight
            }
        }
    }
    
    // MARK: - Outlets
    
    /// - Tag: Transaction Type
    @IBOutlet weak var transactionTypeLabel: UILabel!
    
    /// - Tag: Exclusivity
    @IBOutlet weak var exclusivityTitleLabel: UILabel!
    @IBOutlet weak var exclusivityValueLabel: UILabel!
    @IBOutlet weak var exclusivitySwitch: UISwitch!
    @IBOutlet weak var exclusivityDatePicker: UIDatePicker!
    
    /// - Tag: Sell/Rent
    @IBOutlet weak var sellOrRentSegmentedControl: UISegmentedControl!
    
    /// - Tag: Type
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var typeSubtitleLabel: UILabel!
    
    /// - Tag: Address
    @IBOutlet weak var addressTextField: UITextField!
    
    /// - Tag: Size
    @IBOutlet weak var sizeTextField: UITextField!
    
    /// - Tag: Enter Date
    @IBOutlet weak var enterDateTitleLabel: UILabel!
    @IBOutlet weak var enterDateValueLabel: UILabel!
    @IBOutlet weak var enterDateSwitch: UISwitch!
    @IBOutlet weak var enterDatePicker: UIDatePicker!
    
    @IBOutlet weak var enterDateImmediateTitleLabel: UILabel!
    @IBOutlet weak var enterNowSwitch: UISwitch!
    
    /// - Tag: Rooms
    @IBOutlet weak var roomsTitleLabel: UILabel!
    @IBOutlet weak var roomsTextField: UITextField!
    
    /// - Tag: Balcony
    @IBOutlet weak var balconyTitleLabel: UILabel!
    @IBOutlet weak var balconyTextField: UITextField!
    
    /// - Tag: Parking
    @IBOutlet weak var parkingTitleLabel: UILabel!
    @IBOutlet weak var parkingTextField: UITextField!
    
    /// - Tag: Floor
    @IBOutlet weak var floorNumberTitleLabel: UILabel!
    @IBOutlet weak var totalFloorNumberTitleLabel: UILabel!
    @IBOutlet weak var floorNumberTextField: UITextField!
    @IBOutlet weak var totalFloorNumberTextField: UITextField!
    
    /// - Tag: Extra Info
    @IBOutlet weak var extraInfoTitleLabel: UILabel!
    @IBOutlet weak var extraInfoTextView: UITextView!
    
    /// - Tag: Price
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currencySignLabel: UILabel!
    
    /// - Tag: Images
    @IBOutlet weak var deletePhotosButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    var dataProvider: PropertyProvider?
    
    private lazy var locationPicker: LocationPickerViewController = {
        let locationPicker = LocationPickerViewController()
        locationPicker.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeLocationController))
        locationPicker.title = NSLocalizedString("place", comment: "")
        locationPicker.modalPresentationStyle = .fullScreen
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        return locationPicker
    }()
    
    private lazy var imagePicker: ImagePickerController = {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        // imagePickerController.imageLimit = 5
        imagePickerController.modalPresentationStyle = .fullScreen
        return imagePickerController
    }()
    
        
    private lazy var cameraImage: UIImage? = {
        return UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
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
    
    override func loadView() {
        super.loadView()
        assert(self.dataProvider != nil, "self.dataProvider cannot be nil")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    deinit {
        self.images.removeAll()
    }
    
    private func setupUI() {
        self.title = NSLocalizedString("new", comment: "")
                
        self.transactionTypeLabel.text = NSLocalizedString("transaction_type", comment: "")
        self.exclusivityTitleLabel.text = NSLocalizedString("exclusivity", comment: "") + " (" + NSLocalizedString("due_date", comment: "") + ")"
        self.sellOrRentSegmentedControl.setTitle(NSLocalizedString("sell", comment: ""), forSegmentAt: 0)
        self.sellOrRentSegmentedControl.setTitle(NSLocalizedString("rent", comment: ""), forSegmentAt: 1)
        self.typeTitleLabel.text = NSLocalizedString("property_type", comment: "")
        self.enterDateTitleLabel.text = NSLocalizedString("entry_date", comment: "")
        self.enterDateImmediateTitleLabel.text = NSLocalizedString("entry_available_immediately", comment: "")
        self.addressTextField.placeholder = NSLocalizedString("address", comment: "")
        self.sizeTextField.placeholder = NSLocalizedString("size_in_meters", comment: "")
        self.floorNumberTitleLabel.text = NSLocalizedString("floor_number", comment: "")
        self.totalFloorNumberTitleLabel.text = NSLocalizedString("out_of", comment: "")
        self.roomsTitleLabel.text = NSLocalizedString("number_of_rooms", comment: "")
        self.balconyTitleLabel.text = NSLocalizedString("balcony", comment: "")
        self.parkingTitleLabel.text = NSLocalizedString("parking", comment: "")
        self.extraInfoTitleLabel.text = NSLocalizedString("more_info", comment: "")
        self.priceTitleLabel.text = NSLocalizedString("price", comment: "")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.saveAndClose))
                
        self.sizeTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.floorNumberTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.totalFloorNumberTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.priceTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.extraInfoTextView.addTollbar(target: self, action: #selector(self.closeKeyboard))
        self.addressTextField.addMapTollbar(target: self, action: #selector(self.showLocationPicker))
        
        self.extraInfoTextView.layer.cornerRadius = 3
        self.extraInfoTextView.layer.borderWidth = 2
        self.extraInfoTextView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
                        
        self.typeSubtitleLabel.text = Application.AssetType.allCases[0].localized()
        
        self.enterDateValueLabel.text = ""
        self.enterDateValueLabel.isHidden = true
        self.enterDatePicker.isHidden = true
        self.enterDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.exclusivityValueLabel.text = ""
        self.exclusivityValueLabel.isHidden = true
        self.exclusivityDatePicker.isHidden = true
        self.exclusivityDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.currencySignLabel.text = Application.SpecialCharacters.localizedCurrencySign
        
        self.tableView.estimatedRowHeight = Constants.defaultCellHeight
        
        self.galleryCollectionView.register(className: MiniGalleryCollectionViewCell.self)
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
    
    private func showSelectCategory() {
        let checkboxController = CheckboxTableViewController(style: .insetGrouped)
        checkboxController.delegate = self
        checkboxController.values = Application.AssetType.valuesLocalized()
        checkboxController.defaultSelectedIndex = self.selectedAssetType
        checkboxController.view.bounds = self.view.bounds
        checkboxController.view.frame = self.view.frame
        self.navigationController?.pushViewController(checkboxController, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AddPropertyTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = SectionType(rawValue: section) else { return 0 }
        return type.numberOfRows()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = SectionType(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        
        if type == .entryDate {
            if indexPath.row == 0 {
                return Constants.defaultCellHeight
            } else {
                return type.height(isExpanded: self.enterDateSwitch.isOn, indexPath: indexPath)
            }
        } else if type == .exclusivityDate {
            if indexPath.row == 0 {
                return Constants.defaultCellHeight
            } else {
                return type.height(isExpanded: self.exclusivitySwitch.isOn, indexPath: indexPath)
            }
        }
        
        return type.height(isExpanded: false, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = SectionType(rawValue: indexPath.section) else { return }
        if type == .types && indexPath.row == 1 {
            self.showSelectCategory()
        }
    }
    
}

// MARK: - General Methods

extension AddPropertyTableViewController {
    
    @objc func saveAndClose() {
        // save to core data
        var configuration = PropertyConfiguration(uuid: self.propertyUUID,
                                                  date: Date(),
                                                  enterDateIsNow: self.enterNowSwitch.isOn,
                                                  entryDate: self.enterDate,
                                                  type: Int16(self.selectedAssetType),
                                                  address: self.addressTextField.text,
                                                  price: self.priceTextField.text,
                                                  extraInfo: self.extraInfoTextView.text,
                                                  contactIdentifier: self.contactIdentifier,
                                                  isExclusivity: self.exclusivitySwitch.isOn,
                                                  exclusivityEndDate: self.exclusivityEndDate)
                
        if let location: Location = self.location {
            configuration.latitude = location.coordinate.latitude
            configuration.longitude = location.coordinate.longitude
        }
        if let sellOrRent: String = self.sellOrRentSegmentedControl.titleForSegment(at: self.sellOrRentSegmentedControl.selectedSegmentIndex) {
            configuration.sellOrRent = sellOrRent
        }
        if let size: String = self.sizeTextField.text {
            configuration.size = Double(size)
        }
        if let rooms: String = self.roomsTextField.text, rooms != "0", rooms != "0.0" {
            configuration.rooms = Double(rooms)
        }
        if let balcony: String = self.balconyTextField.text, balcony != "0", balcony != "0.0" {
            configuration.balcony = Int16(balcony)
        }
        if let parking: String = self.parkingTextField.text, parking != "0", parking != "0.0" {
            configuration.parking = Int16(parking)
        }
        if let floorNumber: String = self.floorNumberTextField.text {
            configuration.floorNumber = Int16(floorNumber)
        }
        if let totalFloorNumber: String = self.totalFloorNumberTextField.text {
            configuration.totalFloorNumber = Int16(totalFloorNumber)
        }
        
        self.showSpinner()
        
        ImageStorage.shared.save(images: self.images, propertyId: self.propertyUUID)
        
        self.dataProvider?.addProperty(configuration: configuration) { [weak self] in
            guard let self = self else { return }
            // self.didUpdatePost(post)
            self.hideSpinner()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    private func showPickerView(pickerView: UIDatePicker, valueLabel: UILabel) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        pickerView.alpha = 0.0
        valueLabel.alpha = 0.0
        
        UIView.animate(withDuration: 0.25) {
            pickerView.alpha = 1.0
            valueLabel.alpha = 1.0
        } completion: { (isFinished: Bool) in
            pickerView.isHidden = false
            valueLabel.isHidden = false
        }
    }
    
    private func hidePickerView(pickerView: UIDatePicker, valueLabel: UILabel) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.animate(withDuration: 0.25) {
            pickerView.alpha = 0.0
            valueLabel.alpha = 0.0
        } completion: { (isFinished: Bool) in
            pickerView.isHidden = true
            valueLabel.isHidden = true
        }
    }
    
    private func showEntryDatePicker() {
        self.showPickerView(pickerView: self.enterDatePicker,
                            valueLabel: self.enterDateValueLabel)
    }
    
    private func hideEntryDatePicker() {
        self.hidePickerView(pickerView: self.enterDatePicker,
                            valueLabel: self.enterDateValueLabel)
    }
    
    private func showExclusivityDatePicker() {
        self.showPickerView(pickerView: self.exclusivityDatePicker,
                            valueLabel: self.exclusivityValueLabel)
    }
    
    private func hideExclusivityDatePicker() {
        self.hidePickerView(pickerView: self.exclusivityDatePicker,
                            valueLabel: self.exclusivityValueLabel)
    }
    
}

// MARK: - CheckboxTableViewController

extension AddPropertyTableViewController: CheckboxTableViewControllerDelegate {
    
    func checkboxTableView(_ checkboxTableView: CheckboxTableViewController, didSelectRowAt index: Int) {
        self.selectedAssetType = index
        self.typeSubtitleLabel.text = Application.AssetType.allCases[index].localized()
    }
    
}

// MARK: - Location Picker

extension AddPropertyTableViewController {
    
    @objc private func closeLocationController() {
        self.locationPicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ImagePickerDelegate

extension AddPropertyTableViewController: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.images = images
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Action Handlers

extension AddPropertyTableViewController {
    
    @IBAction private func onPressExlusivitySwitch(_ sender: Any) {
        guard let dateSwitch = sender as? UISwitch else { return }
        self.exclusivityValueLabel.text = NSLocalizedString("today", comment: "")
        
        if dateSwitch.isOn {
            self.showExclusivityDatePicker()
        } else {
            self.hideExclusivityDatePicker()
        }
    }
    
    @IBAction private func onExlusivityDatePickerValueChange(_ sender: Any) {
        guard let picker = sender as? UIDatePicker else { return }
        self.exclusivityValueLabel.text = DateFormatter.dayFormatter.string(from: picker.date)
    }
    
    @IBAction func OnPressDatePickerSwitch(_ sender: Any) {
        guard let dateSwitch = sender as? UISwitch else { return }
        self.enterDateValueLabel.text = NSLocalizedString("today", comment: "")
        
        if dateSwitch.isOn {
            if self.enterNowSwitch.isOn {
                self.enterNowSwitch.isOn = false
            }
            self.showEntryDatePicker()
        } else {
            self.hideEntryDatePicker()
        }
    }
    
    @IBAction func onEnterDatePickerValueChange(_ sender: Any) {
        guard let picker = sender as? UIDatePicker else { return }
        self.enterDateValueLabel.text = DateFormatter.dayFormatter.string(from: picker.date)
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
        guard let dateSwitch = sender as? UISwitch else { return }
        if dateSwitch.isOn {
            if self.enterDateSwitch.isOn {
                self.enterDateSwitch.isOn = false
                self.hideEntryDatePicker()
            }
        }
    }
    
    @IBAction func onAddImageButton(_ sender: Any) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onPressClearImagesButton(_ sender: Any) {
        self.images.removeAll()
        self.galleryCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension AddPropertyTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(className: MiniGalleryCollectionViewCell.self, indexPath: indexPath)
        cell.imageView.image = self.images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previewViewController = ImagePreviewViewController(image: self.images[indexPath.item])
        let navController = UINavigationController(rootViewController: previewViewController)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
}
