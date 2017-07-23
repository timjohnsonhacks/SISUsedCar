//
//  SISFadeView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/23/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISFadeView: UIView {
    
    var fade: CAGradientLayer!
    
    init(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint) {
        super.init(frame: frame)
        let f = CAGradientLayer()
        f.frame = bounds
        f.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        f.startPoint = startPoint
        f.endPoint = endPoint
        layer.mask = f
        fade = f
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fade.frame = bounds
    }

}
