//
//  Overlay.swift
//  MapStyleDrawer
//
//  Created by joshua kaunert on 8/5/20.
//  Copyright © 2020 Joshua Kaunert. All rights reserved.
//

import UIKit

class Overlay: UIView {

    private var _mask = CAShapeLayer()

//    public var cornerRadius: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.clipsToBounds = false
    }

    override func layoutSubviews() {
        let path = CGMutablePath()

        _mask.frame = self.bounds

        var clipping = self.bounds
        clipping.origin.y = self.bounds.size.height - cornerRadius

        path.addRect(self.bounds)
        path.addRoundedRect(in: clipping, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

        _mask.path = path
        #if swift(>=4.2)
        _mask.fillRule = .evenOdd
        #else
        _mask.fillRule = kCAFillRuleEvenOdd
        #endif

        self.layer.mask = _mask
    }
}
