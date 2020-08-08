//
//  ViewController.swift
//  MapStyleDrawer
//
//  Created by joshua kaunert on 8/5/20.
//  Copyright © 2020 Joshua Kaunert. All rights reserved.
//

import UIKit
import MapKit
import WebKit
import ARKit


enum DrawerPresentationType {
    case none
    case drawer(DrawerView)
    case presentation
}

struct DrawerMapEntry {
    let key: String
    let presentation: DrawerPresentationType
}

extension DrawerMapEntry {
    var drawer: DrawerView? {
        switch presentation {
            case .none:
                return nil
            case .drawer(let drawer):
                return drawer
            case .presentation:
                return nil
        }
    }
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var shipmentMapView: MKMapView!
    
    @IBOutlet weak var drawerView: DrawerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locateButtonContainer: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    //MARK: - Actions ⚡️
    @IBAction func closeButtonTapped(_ sender: Any) {
                print("button tapped")
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        
    //Mock Data Source
    var listItems: [Any] = []
    var headerItems: [Any] = []
    
    //Drawer Entry
    var drawers: [DrawerMapEntry] = []
    
    //MARK: Location Manager
    let locationManager = CLLocationManager()
    
    var scannARNetworkingController: ScannARNetworkController?
    var shipment: Shipment?
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        shipment = Shipment(carrierName: "USPS",dimensions: "42x42x42",productNames: ["yaya", "nana", "ohoh", "noodles", "too"], productUuids: nil, shipmentTrackingDetail: nil, shippedDate: Date(), dateArrived: Date(), lastUpdated: Date(), shippingType: "Snail Mail",   totalWeight: 42.0, totalValue: 42.0, status: 2,  trackingNumber: "92748999985493513036555961", shippedTo: "1 Infinite Loop, Cupertino, CA", uuid: UUID())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // We're using safe area insets to reposition the user location
        // button, so remove automatic inset adjustment in the table view.
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        shipmentMapView.delegate = self
        addAnnotation()
        centerMapOnLocation(location: initialLocation)
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.keyboardDismissMode = .onDrag
        
        self.setupLocateButton()
        
        showDrawer(drawer: drawerView, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Mock Tracking Details
    let dateLabelArray = ["April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 12, 2019", "April 11, 2019", "April 11, 2019", "April 11, 2019", "April 11, 2019"]
    let timeLabelArray = ["10:32 am", "8:55 am", "8:45 am", "7:10 am", "6:05 am", "5:09 am", "12:00 am", " ", "9:57 pm", "8:42 pm", "1:23 pm", "7:05 am"]
    let statusLabelArray = ["Delivered, In/At Mailbox", "Out for Delivery", "Sorting Complete", "Arrived at Post Office ", "Arrived at USPS Facility", "Departed USPS Regional Facility", "Arrived at USPS Regional Destination Facility", "In Transit to Next Facility", "Arrived at USPS Regional Origin Facility", "Accepted at USPS Origin Facility", "USPS in possession of item", "Shipping Label Created, USPS Awaiting Item "]
    let currentLocationLabelArray = ["NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "PROVIDENCE RI DISTRIBUTION CENTER", "PROVIDENCE RI DISTRIBUTION CENTER", " ", "CHAMPAIGN IL DISTRIBUTION CENTER", "CHARLESTON, IL 61920", "CHARLESTON, IL 61920", "CHARLESTON, IL 61920"]
    
    // MARK: - Private
    
    let drawerPresentation = DrawerPresentationManager()
        
    private func showDrawer(drawer: DrawerView?, animated: Bool) {
        for another in drawers.compactMap({ $0.drawer }) {
            if another !== drawer {
                another.setConcealed(true, animated: animated)
            } else if another.isConcealed {
                another.setConcealed(false, animated: animated)
            }  else if let nextPosition = another.getNextPosition(offsetBy: 1) ?? another.getNextPosition(offsetBy: -1) {
                another.setPosition(nextPosition, animated: animated)
            }
        }
    }
    
    private func setupDrawer() -> DrawerPresentationType {
        drawerView.snapPositions = [.collapsed, .partiallyOpen, .open]
        drawerView.insetAdjustmentBehavior = .automatic
        drawerView.delegate = self
        drawerView.position = .collapsed
        
        return .drawer(drawerView)
    }
    
    private func setupLocateButton() {
        let locateButton = MKUserTrackingButton(mapView: self.shipmentMapView)
        locateButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        locateButton.frame = self.locateButtonContainer.bounds
        self.locateButtonContainer.addSubview(locateButton)
        
        self.locateButtonContainer.layer.borderColor = UIColor(white: 0.2, alpha: 0.2).cgColor
        self.locateButtonContainer.backgroundColor = UIColor(hue: 0.13, saturation: 0.03, brightness: 0.97, alpha: 1.0)
        self.locateButtonContainer.layer.borderWidth = 0.5
        self.locateButtonContainer.layer.cornerRadius = 8
        self.locateButtonContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.locateButtonContainer.layer.shadowRadius = 2
        self.locateButtonContainer.layer.shadowOpacity = 0.1
    }
    
    private func addAnnotation() {
        //        let address = model?.shippedTo
        guard let address = shipment?.shippedTo else { return }
        let geocoder = CLGeocoder()
        let destination = MKPointAnnotation()
        destination.title = address
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                NSLog("Error: \(error!)")
            }
            if let placemark = placemarks?.first {
                destination.coordinate = placemark.location!.coordinate
                self.centerMapOnLocation(location: placemark.location!)
            }
        })
        
        DispatchQueue.main.async {
            self.shipmentMapView.addAnnotation(destination)
        }
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        shipmentMapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension MapViewController: DrawerViewDelegate {
    
    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        print("drawer(_:willTransitionFrom: \(startPosition) to: \(targetPosition))")
        if startPosition == .open {
            searchBar.resignFirstResponder()
        }
    }
    
    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
        print("drawerView(_:didTransitionTo: \(position))")
    }
    
    func drawerWillBeginDragging(_ drawerView: DrawerView) {
        print("drawerWillBeginDragging")
    }
    
    func drawerWillEndDragging(_ drawerView: DrawerView) {
        print("drawerWillEndDragging")
    }
    
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
        let maxOffset = drawers
            // Ignore modal for safe area insets.
            .filter { $0.drawer !== drawers["modal"]?.drawer }
            .compactMap { $0.drawer?.drawerOffset }
            .max()
        self.additionalSafeAreaInsets.bottom = min(maxOffset ?? 0, drawerView.partiallyOpenHeight)
        
        // Round the corners of the toolbar view when open.
        if drawerView === drawers["toolbar"]?.drawer {
            let offset = drawerView.drawerOffset - drawerView.collapsedHeight
            drawerView.cornerRadius = min(offset / 5, 9)
        }
    }
}

extension MapViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12 //items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MapDrawerTableViewCell", for: indexPath) as! MapDrawerTableViewCell
        
        guard let shipment = shipment else { fatalError("No shipment passed to this VC") }
        cell.backgroundColor = UIColor.clear
        
        cell.configure(model: shipment)
        cell.trackingCellStatusLabel.text = statusLabelArray[indexPath.row]
        cell.trackingCellDateLabel.text = dateLabelArray[indexPath.row]
        cell.trackingCellTimeLabel.text = timeLabelArray[indexPath.row]
        cell.trackingCellCurrentLocation.text = currentLocationLabelArray[indexPath.row]
        
        return cell
    }
}

extension MapViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        drawerView?.setPosition(.collapsed, animated: true)
    }
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        drawerView?.setPosition(.open, animated: true)
    }
}
extension MapViewController: MKMapViewDelegate {
    // MARK: - MapViewDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last as CLLocation? else { return }
        
        // Does not have to be userCenter. replace latitude: and longitude: with the coordinate values you would like to set as center
        let userCenter = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        DispatchQueue.main.async {
            self.shipmentMapView.setRegion(region, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            DispatchQueue.main.async {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            }
            
        } else {
            DispatchQueue.main.async {
                annotationView!.annotation = annotation
            }
        }
        
        return annotationView
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.overCurrentContext
    }
}

extension Sequence where Element == DrawerMapEntry {
    
    subscript(key: String) -> DrawerMapEntry? {
        return self.first { $0.key == key }
    }
}

