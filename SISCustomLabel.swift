//
//  SISCustomLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISCustomLabel: UILabel {
    
    var insets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
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
