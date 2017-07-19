//
//  SISUsedCarImage.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarImage {
    
    let fullPath: String
    let orderId: Int
    var image: UIImage?
    var downloadAttemptFailed: Bool = false
    
    init(fullPath: String, orderId: Int) {
        self.fullPath = fullPath
        self.orderId = orderId
    }
}
