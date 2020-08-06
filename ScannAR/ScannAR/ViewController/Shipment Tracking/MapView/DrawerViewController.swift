//
//  DrawerViewController.swift
//  MapStyleDrawer
//
//  Created by joshua kaunert on 8/5/20.
//  Copyright © 2020 Joshua Kaunert. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findParentDrawerView(ofView view: UIView?) -> DrawerView? {
        switch view?.superview {
            case .none:
                return nil
            case .some(let parent):
                return parent as? DrawerView ?? findParentDrawerView(ofView: view)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


