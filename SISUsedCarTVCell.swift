//
//  SISUsedCarTVCell.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarTVCell: UITableViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var yearMakeModelLabel: UILabel!
    @IBOutlet weak var isSoldLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // car image view config
        carImageView.contentMode = .scaleAspectFit
    }

    func configure(yearMakeModel: String, isSold: String, price: String) {
        yearMakeModelLabel.text = yearMakeModel
        isSoldLabel.text = isSold
        priceLabel.text = price
    }
    
    func configure(image: UIImage) {
        carImageView.image = image
    }
}
