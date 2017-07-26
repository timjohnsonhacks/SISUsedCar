//
//  SISUsedCarDetailCVCell.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailCVCell: UICollectionViewCell {
    
    weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /* create views programatically. Xib is useless because it gives you no access to the contentView, which is the superview for normally displayed content */
        let iv = UIImageView(image: nil)
        contentView.addBoundsFillingSubview(iv)
        imageView = iv
        imageView.contentMode = .scaleAspectFit

        
        layoutMargins = .zero
    }
    
    func configureBorder(_ border: Bool) {
        switch border {
        case true:
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 8.0
            imageView.layer.borderColor = UIColor.darkGray.cgColor
            imageView.layer.borderWidth = 2.0
            
        case false:
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 0.0
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.layer.borderWidth = 0.0
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
