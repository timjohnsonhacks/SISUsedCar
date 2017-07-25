//
//  SISSearchPageButton.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISSearchPageButton: UIButton {

    let color_1: UIColor
    let color_2: UIColor
    let titleNumber: Int
    let borderWidth: CGFloat
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                backgroundColor = color_1
            } else if isSelected == false {
                backgroundColor = color_2
            }
        }
    }
    
    init(color_1: UIColor, color_2: UIColor, titleNumber: Int, borderWidth: CGFloat, isSelected: Bool) {
        self.color_1 = color_1
        self.color_2 = color_2
        self.titleNumber = titleNumber
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        self.isSelected = isSelected
        
        setTitle(String(titleNumber), for: .normal)
        setTitle(String(titleNumber), for: .selected)
        setTitleColor(color_1, for: .normal)
        setTitleColor(color_2, for: .selected)
        titleLabel?.textAlignment = .center
        layer.borderWidth = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
