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
    
    weak var activityView: UIActivityIndicatorView?

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
        if let activityView = activityView {
            activityView.stopAnimating()
        }
        carImageView.image = image
    }
    
    func showActivityIndicator() {
        if let activityView = activityView {
            activityView.startAnimating()
        } else {
            let av = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            av.translatesAutoresizingMaskIntoConstraints = false
            carImageView.superview?.insertSubview(av, aboveSubview: carImageView)
            
            let attributes: [NSLayoutAttribute] = [.top, .bottom, .left, .right]
            for attr in attributes {
                let constraint = NSLayoutConstraint.init(item: av, attribute: attr, relatedBy: .equal, toItem: carImageView, attribute: attr, multiplier: 1.0, constant: 0.0)
                carImageView.superview?.addConstraint(constraint)
            }
            
            av.startAnimating()
        }
    }
}
