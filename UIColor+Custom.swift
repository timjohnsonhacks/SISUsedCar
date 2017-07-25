//
//  UIColor+Custom.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(absoluteRed: Float, absoluteGreen: Float, absoluteBlue: Float) {
        let max: Float = 255.0
        self.init(
            colorLiteralRed: absoluteRed / max,
            green: absoluteGreen / max,
            blue: absoluteBlue / max,
            alpha: 1.0)
    }
}
