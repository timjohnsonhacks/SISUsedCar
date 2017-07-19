//
//  SISAutoLayoutUtility.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISAutoLayoutUtility {
}

extension UIView {
    func insertSubviewAboveWithMatchingFrame(_ view: UIView) {
        self.superview?.insertSubview(view, aboveSubview: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutAttribute] = [.top, .bottom, .left, .right]
        for attr in attributes {
            let constraint = NSLayoutConstraint.init(item: view, attribute: attr, relatedBy: .equal, toItem: self, attribute: attr, multiplier: 1.0, constant: 0.0)
            self.superview?.addConstraint(constraint)
        }
    }
}
