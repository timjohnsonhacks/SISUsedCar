//
//  SISCustomLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISCustomLabel: UILabel {
    
    let insets: UIEdgeInsets
    
    init(frame: CGRect, insets: UIEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)) {
        self.insets = insets
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func drawText(in rect: CGRect) {
        let drawRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: drawRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let oldSize = super.intrinsicContentSize
        return CGSize(width: oldSize.width, height: oldSize.height + insets.top + insets.bottom)
    }

}
