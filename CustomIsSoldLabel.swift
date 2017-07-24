//
//  CustomIsSoldLabel.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class CustomIsSoldLabel: UILabel {
    
    var scaleFactor: CGFloat = 1.3
    var cornerRadii: CGSize = CGSize(width: 8.0, height: 8.0)
    var thickness: CGFloat = 2.0
    var partialBorder: CAShapeLayer?
    var color: UIColor = .black {
        didSet {
            textColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override var intrinsicContentSize: CGSize {
        let oldSize = super.intrinsicContentSize
        let newSize = CGSize(width: oldSize.width * scaleFactor,
                             height: oldSize.height * scaleFactor)
        return newSize
    }
    
    override func drawText(in rect: CGRect) {
        let fitSize = sizeThatFits(rect.size)
        let drawRect = CGRect(
            x: rect.size.width - fitSize.width,
            y: 0,
            width: fitSize.width,
            height: fitSize.height)
        super.drawText(in: drawRect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetPartialBorder()
    }
    
    func resetPartialBorder() {
        partialBorder?.removeFromSuperlayer()
        let newPartialBorder = partialBorderLayer()
        layer.addSublayer(newPartialBorder)
        partialBorder = newPartialBorder
    }
    
    func partialBorderLayer() -> CAShapeLayer {
        let path = UIBezierPath()
        
        let point_1 = CGPoint(x: thickness / 2.0, y: 0.0)
        let point_2 = CGPoint(x: thickness / 2.0, y: bounds.height - cornerRadii.height - thickness / 2.0)
        let point_3 = CGPoint(x: cornerRadii.width + thickness / 2.0, y: bounds.height - thickness / 2.0)
        let point_4 = CGPoint(x: bounds.width, y: bounds.height - thickness / 2.0)
        path.move(to: point_1)
        path.addLine(to: point_2)
        path.addQuadCurve(to: point_3,
                          controlPoint: CGPoint(
                            x: 0.0,
                            y: bounds.height))
        path.addLine(to: point_4)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = thickness
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        return shapeLayer
    }
}









