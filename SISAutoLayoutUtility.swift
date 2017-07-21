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
    
    func addBoundsFillingSubview(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : view]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : view]))
    }
    
    func addLayoutBasedBorder(edge: UIRectEdge, thickness: CGFloat, color: UIColor) {
        let borderView = UIView()
        var horzVfl: String?
        var vertVfl: String?
        let mapping: [String : Any] = ["border" : borderView]
        
        switch edge {
        case UIRectEdge.top:
            horzVfl = "H:|-0-[border]-0-|"
            vertVfl = "V:|-0-[border(==\(thickness))]"
        case UIRectEdge.bottom:
            horzVfl = "H:|-0-[border]-0-|"
            vertVfl = "V:[border(==\(thickness))]-0-|"
        default:
            return
        }
        
        if let horzVfl = horzVfl, let vertVfl = vertVfl {
            addSubview(borderView)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            let horzConstr = NSLayoutConstraint.constraints(withVisualFormat: horzVfl, options: [], metrics: nil, views: mapping)
            let vertConstr = NSLayoutConstraint.constraints(withVisualFormat: vertVfl, options: [], metrics: nil, views: mapping)
            NSLayoutConstraint.activate(horzConstr)
            NSLayoutConstraint.activate(vertConstr)
            
            borderView.backgroundColor = color
        }
        
    }
}

extension UIView {
    
    func addBorder(edge: UIRectEdge, thickness: CGFloat, color: UIColor) {
        let borderLayer = CALayer()

        switch edge {
        case UIRectEdge.top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: thickness)
        default:
            return
        }
        borderLayer.backgroundColor = color.cgColor
        layer.addSublayer(borderLayer)
    }
}
