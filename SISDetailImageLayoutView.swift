//
//  SISDetailImageLayoutView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/26/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDetailImageLayoutView: UIView {

    let largeImageContainer: UIView
    let smallImageContainer: UIView
    let aspectRatio: CGFloat
    let smallHeight: CGFloat
    let largeSmallVerticalSpacing: CGFloat
    var verticalConstraints: [NSLayoutConstraint]!
    var mapping: [String : UIView] {
        return ["large" : largeImageContainer,
                "small" : smallImageContainer]
    }

    init(frame: CGRect, largeImageContainer: UIView, smallImageContainer: UIView, aspectRatio: CGFloat = SISGlobalConstants.defaultAspectRatio, smallHeight: CGFloat = 60.0, largeSmallVerticalSpacing: CGFloat = 10.0) {
        self.largeImageContainer = largeImageContainer
        self.smallImageContainer = smallImageContainer
        self.aspectRatio = aspectRatio
        self.smallHeight = smallHeight
        self.largeSmallVerticalSpacing = largeSmallVerticalSpacing
        super.init(frame: frame)
        
        for (name, v) in mapping {
            addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[\(name)]-0-|",
                options: [],
                metrics: nil,
                views: mapping))
        }
        verticalConstraints = calculatedVerticalConstraints()
        addConstraints(verticalConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculatedVerticalConstraints() -> [NSLayoutConstraint] {
        let largeHeight: CGFloat = bounds.size.width / aspectRatio
        return NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[large(==\(largeHeight))]-\(largeSmallVerticalSpacing)-[small(==\(smallHeight))]",
                options: [],
                metrics: nil,
                views: mapping)
    }
    
    override func layoutSubviews() {
        removeConstraints(verticalConstraints)
        let newConstr = calculatedVerticalConstraints()
        addConstraints(newConstr)
        super.layoutSubviews()
    }
    
}
