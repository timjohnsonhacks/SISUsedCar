//
//  SISUsedCarDetailCVCell.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFit
    }

}
