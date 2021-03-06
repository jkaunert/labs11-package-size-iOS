//
//  AddProductContainerViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/24/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class AddProductContainerViewController: ShiftableViewController {

    
    
//    @IBAction func unwindToAddProductVC(segue: UIStoryboardSegue) {
//        let transition: CATransition = CATransition()
//        transition.duration = 0.7
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        self.navigationController!.view.layer.add(transition, forKey: nil)
//        if let sourceVC = segue.source as? ARScanViewController {
//
//            bestBoxSize = sourceVC.boundingBoxSize
//            previewImage = sourceVC.previewImage!
//            name = sourceVC.scannedObjectName
//        }
//    }
    var bestBoxSize: (length: Float?, width: Float?, height: Float?)
    var previewImage: UIImage = UIImage()
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: TextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let childVC = self.children[0] as! AddProductViewController
        switch textField.tag {
            
        case 0:
            childVC.manufacturerId = textField.text!
        case 1:
            childVC.weight = Double("\(textField.text!)") ?? 0.0
        default:
            childVC.value = Double("\(textField.text!)") ?? 0.0
            
        }
        
    }
    
    // MARK: - Navigation

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EmbedSegue" {
            guard let destVC = segue.destination as? AddProductViewController else { fatalError("Segue should cast view controller as AddProductViewController but failed to do so.")}
            destVC.shiftableVCDelegate = self as ShiftableViewController
            destVC.bestBoxSize = self.bestBoxSize
            destVC.previewImage = self.previewImage
            destVC.name = self.name
        }
        
    }

}
