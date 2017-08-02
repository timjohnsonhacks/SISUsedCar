//
//  SISCheckPairLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 8/2/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISCheckPairLabel: UIView {

    var stack: UIStackView!
    var leftLabel: SISCheckLabel!
    var rightLabel: SISCheckLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        leftLabel = newCheckLabel()
        rightLabel = newCheckLabel()
        stack = UIStackView(arrangedSubviews: [])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.backgroundColor = .clear
    }
    
    private func newCheckLabel() -> SISCheckLabel {
        let cl = UINib(nibName: "SISCheckLabel", bundle: nil).instantiate(withOwner: self, options: nil).first! as! SISCheckLabel
        return cl
    }
    
    public func configure(leftText: String?, rightText: String?) {
        if let leftText = leftText {
            leftLabel.textLabel.text = leftText
            stack.addArrangedSubview(leftLabel)
        }
        
        if let rightText = rightText {
            rightLabel.textLabel.text = rightText
            stack.addArrangedSubview(rightLabel)
        }
        
        if stack.arrangedSubviews.count > 0 {
            addBoundsFillingSubview(stack)
        }
    }
}
