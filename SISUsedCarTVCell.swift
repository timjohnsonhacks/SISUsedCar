//
//  SISUsedCarTVCell.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit
import CoreGraphics

class SISUsedCarTVCell: UITableViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var yearMakeModelLabel: UILabel!
    @IBOutlet weak var isSoldLabel: CustomIsSoldLabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var priceContainer: UIView!
    @IBOutlet weak var mileageContainer: UIView!
    
    weak var activityView: UIActivityIndicatorView?
    weak var gradient: CAGradientLayer!
    weak var noImageLabel: UILabel?
    
    let red = UIColor(
        colorLiteralRed: 188.0 / 255.0,
        green: 21.0 / 255.0,
        blue: 48.0 / 255.0,
        alpha: 1.0)
    
    let green = UIColor(
        colorLiteralRed: 34.0 / 255.0,
        green: 176.0 / 255.0,
        blue: 19.0 / 255.0,
        alpha: 1.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // car image view config
        carImageView.contentMode = .scaleAspectFit
        
        // label config
        yearMakeModelLabel.numberOfLines = 0
        yearMakeModelLabel.lineBreakMode = .byWordWrapping
        yearMakeModelLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        isSoldLabel.font = UIFont.boldSystemFont(ofSize: 15)
        isSoldLabel.textColor = UIColor.white
        
        let containers = [priceContainer, mileageContainer]
        for cont in containers {
            cont?.layer.borderColor = UIColor.black.cgColor
            cont?.layer.borderWidth = 0.5
            cont?.layer.cornerRadius = 8.0
            cont?.layer.masksToBounds = true
        }
        
        // setup gradient layer
        let gl = CAGradientLayer()
        gl.colors = [UIColor.white.cgColor, UIColor.lightGray.cgColor]
        gl.startPoint = CGPoint(x: 0.0, y: 0.0)
        gl.endPoint = CGPoint(x: 1.0, y: 1.0)
        let bv = UIView()
        bv.layer.addSublayer(gl)
        backgroundView = bv
        gradient = gl
    }

    func configure(yearMakeModel: String, isSold: Bool, price: String, mileage: String) {
        yearMakeModelLabel.text = yearMakeModel
        priceLabel.text = price
        mileageLabel.text = mileage
        if isSold == true {
            isSoldLabel.text = "Sold"
            isSoldLabel.color = red
        } else {
            isSoldLabel.text = "Available"
            isSoldLabel.color = green
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = backgroundView!.bounds
    }
}

















