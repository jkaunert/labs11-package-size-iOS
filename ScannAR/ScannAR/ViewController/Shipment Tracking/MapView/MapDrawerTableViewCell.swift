//
//  MapDrawerTableViewCell.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/18/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

//struct ShipmentStatus {
//    static let dict: [Int:String] = [0: "Unknown",
//                                     1: "Shipping",
//                                     2: "En-Route",
//                                     3: "Out-For-Delivery",
//                                     4: "Delivered",
//                                     5: "Delayed"]
//}
//
//struct Shipment {
//    let carrierLogoImage: UIImage?
//    let carrierName: String?
//    let dateArrived: Date?
//    let lastUpdated: Date?
//    let productNames: [String]?
//    let shippedDate: Date?
//    let shippedTo: String?
//    let shippingType: String?
//    let status: Int16
//    let totalValue: Double
//    let totalWeight: Double
//    let trackingNumber: String?
//    let uuid: UUID?
//}
//
//struct MockTrackingDataModel {
//    let date: String
//    let time: String
//    let status: String
//    let currentLocation: String
//}

class MapDrawerTableViewCell: UITableViewCell {
    
    
//    var model: MockShipmentModel!
    var scannARNetworkingController: ScannARNetworkController?
    var shipment: Shipment?
    @IBOutlet weak var trackingCellStatusLabel: UILabel!
    @IBOutlet weak var trackingCellDateLabel: UILabel!
    @IBOutlet weak var trackingCellTimeLabel: UILabel!
    @IBOutlet weak var trackingCellCurrentLocation: UILabel!
    @IBOutlet weak var carrierLogoImageView: UIImageView!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var carrierNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shippedToLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var shippedDateLabel: UILabel!
    @IBOutlet weak var shippingTypeLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    //    @IBOutlet weak var dateArrivedLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(model: Shipment){

        trackingNumberLabel.text = model.trackingNumber
        carrierLogoImageView.image = UIImage(named: "1970-standing-eagle-logo")
        carrierNameLabel.text = model.carrierName
        statusLabel.text = ShipmentStatus.dict[Int(model.status)]
        shippedToLabel.text = model.shippedTo
        totalValueLabel.text = "\(model.totalValue)"
        totalWeightLabel.text = "\(model.totalWeight)"
        shippingTypeLabel.text = model.shippingType
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateArrived = model.dateArrived {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: dateArrived)
        } else {
            lastUpdatedLabel.text = "No Status Information Available."
        }
        
        if let shippedDate = model.shippedDate {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: shippedDate)
            shippedDateLabel.text = dateFormatter.string(from: shippedDate)
        } else {
            shippedDateLabel.text = "No Status Information Available."
        }
        
        if let lastUpdated = model.lastUpdated {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: lastUpdated)
        }
    }
    
    open func updateViews(){
        guard let model = shipment else { fatalError("No model passed to this VC") }
        trackingNumberLabel.text = model.trackingNumber
        carrierNameLabel.text = model.carrierName
        statusLabel.text = ShipmentStatus.dict[Int(model.status)]
        shippedToLabel.text = model.shippedTo
        totalValueLabel.text = "\(model.totalValue)"
        totalWeightLabel.text = "\(model.totalWeight)"
        shippingTypeLabel.text = model.shippingType
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateArrived = model.dateArrived {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: dateArrived)
        } else {
            lastUpdatedLabel.text = "No Status Information Available."
        }
        
        if let shippedDate = model.shippedDate {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: shippedDate)
            shippedDateLabel.text = dateFormatter.string(from: shippedDate)
        } else {
            shippedDateLabel.text = "No Status Information Available."
        }
        
        if let lastUpdated = model.lastUpdated {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: lastUpdated)
        }
        
    }
}

