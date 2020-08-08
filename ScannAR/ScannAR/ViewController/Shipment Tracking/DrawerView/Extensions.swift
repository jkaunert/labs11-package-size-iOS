//
//  Extensions.swift
//  MapStyleDrawer
//
//  Created by joshua kaunert on 8/5/20.
//  Copyright © 2020 Joshua Kaunert. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {

    func addDrawerView(withViewController viewController: UIViewController, parentView: UIView? = nil) -> DrawerView {
        #if swift(>=4.2)
        self.addChild(viewController)
        #else
        self.addChildViewController(viewController)
        #endif
        let drawer = DrawerView(withView: viewController.view)
        drawer.attachTo(view: self.view)
        return drawer
    }
}


