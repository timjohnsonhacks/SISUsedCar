//
//  SISUsedCarImage.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

public class SISUsedCarImage {
    
    public let fullPath: String
    public let orderId: Int
    public var image: UIImage?
    public var downloadAttemptFailed: Bool = false
    
    public init(fullPath: String, orderId: Int) {
        self.fullPath = fullPath
        self.orderId = orderId
    }
}
