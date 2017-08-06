//
//  UIView+Custom.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/21/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

/*
* You should do some research into 3rd party libraries. You're doing a lot of things here that are nicely solved with a 
* library called SnapKit. You can install it with cocoapods. I recommend doing some reading on cocoapods or carthage. 
* Pretty much all other iOS engineers use them for external dependencies.
*/

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
    
    func insertWidthFillingStackedViews(_ views: [UIView], height: CGFloat) {
        var mapping: [String: Any] = [:]
        var last: (String, UIView)?
        for (i, v) in views.enumerated() {
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
            let name = "v\(i)"
            mapping[name] = v
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[\(name)]-0-|", options: [], metrics: nil, views: mapping))
            if let last = last {
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(last.0)]-0-[\(name)(>=\(height))]", options: [], metrics: nil, views: mapping))
            } else {
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[\(name)(>=\(height))]", options: [], metrics: nil, views: mapping))
            }
            last = (name, v)
        }
    }
    
    func addRoundedCornersMask(corners: UIRectCorner, radii: CGSize) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        let roundedPath = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: radii)
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.path = roundedPath.cgPath
        
        layer.mask = maskLayer
    }
}








