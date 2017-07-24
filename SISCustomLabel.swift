//
//  SISCustomLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISCustomLabel: UILabel {
    
    var insets: UIEdgeInsets
    let defaultInsets = UIEdgeInsets(top: 3.0, left: 6.0, bottom: 3.0, right: 6.0)
    
    init(frame: CGRect, insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        insets = defaultInsets
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        let drawRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: drawRect)
    }

}
