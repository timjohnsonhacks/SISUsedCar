//
//  SISFeatureLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 8/2/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISFeatureLabel: UIView {

    @IBOutlet weak var nameLabel: SISCustomLabel!
    @IBOutlet weak var valueLabel: SISCustomLabel!
    
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
    }
}
