//
//  SISGradientBackgroundView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/26/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISGradientBackgroundView: UIView {

    weak var gradient: CAGradientLayer!
    
    init(frame: CGRect, gradient: CAGradientLayer) {
        super.init(frame: frame)
        layer.addSublayer(gradient)
        self.gradient = gradient
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

}
