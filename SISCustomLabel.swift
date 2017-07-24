//
//  SISCustomLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISCustomLabel: UILabel {
    
    let insets: UIEdgeInsets = UIEdgeInsetsMake(3.0, 6.0, 3.0, 6.0)

//    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        return CGRect(x: horzInset,
//                      y: vertInset,
//                      width: bounds.size.width - 2.0 * horzInset,
//                      height: bounds.size.height - 2.0 * vertInset)
//    }
    
    override func drawText(in rect: CGRect) {
//        let drawRect = CGRect(x: horzInset,
//                              y: vertInset,
//                              width: rect.size.width - 2.0 * horzInset,
//                              height: rect.size.height - 2.0 * vertInset)
        let drawRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: drawRect)
    }

}
