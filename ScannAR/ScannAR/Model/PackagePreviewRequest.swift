//
//  PackagePreviewRequest.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct PackagePreviewRequest: Codable {
    var products: [String]
    var boxType: BoxType? = nil
}
