//
//  SISSmartScrollView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/26/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISSmartScrollView: UIView {

    var contentView: UIView
    var scrollView: UIScrollView!
//    var scrollViewContentContainer: UIView!
    
    init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
        scrollView = UIScrollView(frame: .zero)
//        scrollViewContentContainer = UIView(frame: .zero)
//        scrollView.addSubview(scrollViewContentContainer)
//        scrollViewContentContainer.insertWidthFillingStackedViews([contentView], height: 0.0)
        scrollView.addSubview(contentView)
        scrollView.contentSize = .zero
        addBoundsFillingSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        contentView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.size.width,
            height: 1000)
        contentView.layoutIfNeeded()
        for v in contentView.subviews {
            print("subview bounds: \(v.bounds)")
        }
        
//        print("smart scroll view bounds: \(bounds)")
//        print("scroll view bounds: \(scrollView.bounds)")
//        var totalHeight: CGFloat = 0.0
//        for v in contentView.subviews {
//            print("subview intrinsic content size: \(v.intrinsicContentSize)")
//            let fitSize = v.sizeThatFits(CGSize(
//                width: bounds.size.width,
//                height: CGFloat.greatestFiniteMagnitude))
//            print("subview fit size: \(fitSize)")
//            totalHeight += fitSize.height
//            print("subview bounds: \(v.bounds)")
            
            
//        }
//        scrollView.contentSize = CGSize(
//            width: bounds.size.width,
//            height: totalHeight)
        
        super.layoutSubviews()
    }
    
}






