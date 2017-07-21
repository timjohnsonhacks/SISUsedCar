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
        
        /* create views programatically; xib is useless because it gives you no access to the contentView, which is the superview for normally displayed content */
        let iv = UIImageView(image: nil)
        contentView.addBoundsFillingSubview(iv)
        imageView = iv
        imageView.contentMode = .scaleAspectFit
        
        layoutMargins = .zero
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        /* create views programatically; xib is useless because it gives you no access to the contentView, which is the superview for normally displayed content */
//        let iv = UIImageView(image: nil)
//        contentView.addBoundsFillingSubview(iv)
//        imageView = iv
//        imageView.contentMode = .scaleAspectFit
//        
//        layoutMargins = .zero
//    }

}
