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
    weak var noImageLabel: UILabel?

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
        activityView?.stopAnimating()
        noImageLabel?.isHidden = true
        carImageView.image = image
    }
    
    func showActivityIndicator() {
        if let activityView = activityView {
            activityView.startAnimating()
        } else {
            let av = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            carImageView.insertSubviewAboveWithMatchingFrame(av)
            activityView = av
            av.startAnimating()
        }
    }
    
    func showNoImageAvailable() {
        activityView?.stopAnimating()
        
        if let noImageLabel = noImageLabel {
            noImageLabel.isHidden = false
        } else {
            let label = UILabel()
            label.text = "No Image Available"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            carImageView.insertSubviewAboveWithMatchingFrame(label)
            noImageLabel = label
        }
    }
    
    func resetImageView() {
        carImageView.image = nil
    }
}
