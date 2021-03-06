//
//  CardsViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class CardsViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cardsView: CardsView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cardsUpIconImageView: UIImageView!
    
    // MARK: Properties
    var boxType: BoxType?
    let storage = PackageConfigViewStorage.shared
    var displayData = [PackageConfiguration]()
    lazy var cardImageViewHeight: CGFloat = cardsView.frame.height * 0.45 //  45% is cell.imageView height constraint's multiplier
    var fetchResults: [PackageConfiguration] = []
    var products: [Product] = []
    let scannARNetworkController = ScannARNetworkController.shared

    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardsUpIconImageView.setImageColor(color: UIColor(named: "appARKADarkBlue")!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setCardsViewLayout()
        storage.data = fetchResults
        storage.boxType = boxType
        if let firstItem = storage.data.first {
            displayData.append(firstItem)
        }
        cardsView.reloadData()  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleViewControllerPresentation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleViewControllerDismiss()
    }
    
    // MARK: Methods
    
    func setCardsViewLayout() {
        view.layoutIfNeeded()
        cardsView.setLayout()
    }

    func handleViewControllerPresentation() {
        if displayData.count == storage.data.count { return }
        cardsView.scrollToItem(at: 0)
        var indexPaths = [IndexPath]()
        for (index, _) in storage.data.enumerated() {
            if index != 0 {
                indexPaths.append(IndexPath(row: index, section: 0))
                displayData.append(storage.data[index])
            }
        }
        cardsView.insertItems(at: indexPaths)
    }
    
    func handleViewControllerDismiss() {
        let amountOfCells = cardsView.numberOfItems(inSection: 0)
        if amountOfCells == 0 { return }
        var indexPathsToDelete = [IndexPath]()
        for index in (1 ..< amountOfCells).reversed() {
            indexPathsToDelete.append(IndexPath(row: index, section: 0))
            displayData.remove(at: index)
        }
        cardsView.deleteItems(at: indexPathsToDelete)
    }
}

// MARK: StoryboardInitialisable Protocol

extension CardsViewController {
    static func instantiateViewController() -> CardsViewController {
        return Storyboard.main.viewController(CardsViewController.self)
    }
}

// MARK: CollectionView DataSource

extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        
        cell.setContent(data: displayData[indexPath.row])
        for view in cell.scrollView.subviews {
            print(view)
            view.removeFromSuperview()
            print(view)
        }
        cell.setScrollView()
        cell.delegate = self
        cell.actionsHandler = self
        cell.pageControl.numberOfPages = displayData[indexPath.row].itemCount
        
        return cell
    }
}

extension CardsViewController: SwipingCollectionViewCellDelegate {
    func cellSwipe(_ cell: SwipingCollectionViewCell, with progress: CGFloat) {
        bottomView.alpha = 1 - progress
        bottomView.transform.ty = progress * 50
    }
    
    func cellSwipedUp(_ cell: SwipingCollectionViewCell) {
        if let interactiveTransitionableViewController = presentingViewController as? InteractiveTransitionableViewController,
            let interactiveDismissTransition = interactiveTransitionableViewController.interactiveDismissTransition {
            interactiveDismissTransition.isEnabled = false
        }
    }
    
    func cellReturnedToInitialState(_ cell: SwipingCollectionViewCell) {
        if let interactiveTransitionableViewController = presentingViewController as? InteractiveTransitionableViewController,
            let interactiveDismissTransition = interactiveTransitionableViewController.interactiveDismissTransition {
            interactiveDismissTransition.isEnabled = true
        }
    }
}

extension CardsViewController: CardCollectionViewCellActionsHandler {
    func savePackageConfigForLaterButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            // Save package config for later without adding to shipment
        }
    }
    
    func addPackageConfigButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            // Add configuration to a shipment
        }
    }
    
    func preview3DButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            performSegue(withIdentifier: "Preview3DSegue", sender: self)
        }
    }
    func deleteButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            storage.data.remove(at: index)
            displayData.remove(at: index)
            cardsView.removeItem(at: index)
        }
        if displayData.isEmpty {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CardsViewController: SmallToLargeAnimatable {
    var animatableBackgroundView: UIView {
        return backgroundView
    }
    
    var animatableMainView: UIView {
        return contentView
    }
    
    func prepareBeingDismissed() {
        cardsView.hideAllCellsExceptSelected(animated: true)
    }
}
