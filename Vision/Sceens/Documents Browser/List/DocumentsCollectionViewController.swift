//
//  DocumentsCollectionViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 15/02/2021.
//

import UIKit

class DocumentsCollectionViewController: UICollectionViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    private let viewModel = DocumentsViewModel()
    private var documentsPicker: DocumentsPickerProvider!
    private let documentPreview = DocumentPreview()
    
    private lazy var addButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.onPressAddFile(_:))
        )
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "documents".localized
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = self.searchController
        
        self.collectionView.backgroundColor = .systemGroupedBackground
                
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout.grid(numberOfItems: 3)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(DocumentCollectionViewCell.self)

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        
        self.documentsPicker = DocumentsPickerProvider()
        self.documentsPicker.delegate = self
        
        self.documentPreview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchFiles { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.files.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DocumentCollectionViewCell.self, indexPath: indexPath)
        let file: File = self.viewModel.files[indexPath.item]
        cell.configure(file)
        cell.delegate = self
        cell.tag = indexPath.item
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let file: File = self.viewModel.files[indexPath.item]
        self.documentPreview.openDocument(file.url)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - Action Handlers

extension DocumentsCollectionViewController {
    
    @objc private func onPressAddFile(_ sender: Any) {
        self.documentsPicker.importDocumentPicker(presenter: self)
    }    
    
}

// MARK: - DocumentsPickerDelegate

extension DocumentsCollectionViewController: DocumentsPickerDelegate {
    
    func documentsPicker(_ picker: DocumentsPickerProvider, didPickDocumentsAt urls: [URL]) {
        self.viewModel.save(files: urls) { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func documentsPickerWasCancelled(_ picker: DocumentsPickerProvider) {
        //
    }
    
}

// MARK: - DocumentPreviewDelegate

extension DocumentsCollectionViewController: DocumentPreviewDelegate {
    
    var presenter: UIViewController {
        return self
    }
    
    func documentPreview(_ preview: DocumentPreview, transitionViewFor file: File?) -> UIView? {
        guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return nil }
        let cell = self.collectionView.cellForItem(at: indexPath)
        return cell
    }
    
    func documentPreview(_ preview: DocumentPreview, didUpdateContentsOf previewFile: File?) {
        //
    }
    
}

// MARK: - DocumentCollectionViewCellDelegate

extension DocumentsCollectionViewController: DocumentCollectionViewCellDelegate {
    func documentCell(_ cell: DocumentCollectionViewCell, onLongPress index: Int) {
        let file: File = self.viewModel.files[index]
        
        let alertController = UIAlertController(title: "delete".localized, message: file.name, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "ok".localized, style: .destructive, handler: { [weak self] (action: UIAlertAction) in
            guard let self = self else { return }
            
            self.viewModel.delete([file.url]) { (success: Bool) in
                if success {
                    let deleteMessage: String = "\(file.name) - \("deleted".localized)"
                    self.view.showMessage(message: (deleteMessage as NSString), animateDuration: 3.0)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
