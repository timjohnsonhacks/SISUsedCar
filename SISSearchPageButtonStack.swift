//
//  SISSearchPageButtonStack.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISSearchPageButtonStack: UIStackView {

    let totalPages: Int
    let buttonSize: CGSize
    let color_1: UIColor
    let color_2: UIColor
    var buttons = [SISSearchPageButton]()
    
    var naturalFrame: CGRect {
        return CGRect(
                x: 0.0,
                y: 0.0,
                width: (buttonSize.width + spacing) * CGFloat(totalPages),
                height: buttonSize.height)
    }
    
    init(totalPages: Int, buttonSize: CGSize, spacing: CGFloat, color_1: UIColor = .black, color_2: UIColor = .white, borderWidth: CGFloat, delegate: SISSearchPageButtonDelegate) {
        self.totalPages = totalPages
        self.buttonSize = buttonSize
        self.color_1 = color_1
        self.color_2 = color_2
        super.init(frame: .zero)
        
        self.spacing = 8.0
        self.frame = naturalFrame
        alignment = .fill
        axis = .horizontal
        distribution = .fillEqually
        
        for i in 0..<totalPages {
            let newButton = SISSearchPageButton(
                color_1: color_1,
                color_2: color_2,
                pageNumber: i,
                borderWidth: borderWidth,
                isSelected: false,
                delegate: delegate)
            buttons.append(newButton)
            addArrangedSubview(newButton)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}











