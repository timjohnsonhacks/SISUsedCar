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
    
    @IBOutlet private weak var downloadingImageView: SISDownloadImageView!
    @IBOutlet private weak var yearMakeModelLabel: UILabel!
    @IBOutlet private weak var isSoldLabel: CustomIsSoldLabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var mileageLabel: UILabel!
    @IBOutlet private weak var priceContainer: UIView!
    @IBOutlet private weak var mileageContainer: UIView!
    
    private weak var gradient: CAGradientLayer!
    
    public var car: SISUsedCar! {
        willSet {
            NotificationCenter.default.removeObserver(self)
        }
        
        didSet {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didDownloadMainImage(notification:)),
                name: Notification.Name.didDownloadMainImage,
                object: car)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    // MARK: - Notifications
    
    @objc private func didDownloadMainImage(notification: Notification) {
        print("did download main image")
        if let main = car.images[0].image {
            DispatchQueue.main.async {
                self.downloadingImageView.configureImage(main)
            }
            return
        } else {
            DispatchQueue.main.async {
                self.downloadingImageView.showNoImageAvailable()
            }
        }
        guard let info = notification.userInfo as? [String:Any],
            let success = info["success"] as? Bool else {
                print("could not decompose info dictionary")
                return
        }
        print("success: \(success)")
    }

    public func configure(yearMakeModel: String, isSold: Bool, price: String, mileage: String) {
        yearMakeModelLabel.text = yearMakeModel
        priceLabel.text = price
        mileageLabel.text = mileage
        isSoldLabel.isSold = isSold
    }
    
    public func configureWithAttributedText(yearMakeModel: NSAttributedString, isSold: Bool, price: String, mileage: String) {
        yearMakeModelLabel.attributedText = yearMakeModel
        priceLabel.text = price
        mileageLabel.text = mileage
        isSoldLabel.isSold = isSold
    }
    
    public func configureImage(_ image: UIImage) {
        downloadingImageView.configureImage(image)
    }
    
    public func showActivityIndicator() {
        downloadingImageView.showActivityIndicator()
    }
    
    public func showNoImageAvailable() {
        downloadingImageView.showNoImageAvailable()
    }
    
    public func reset() {
        downloadingImageView.reset()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = backgroundView!.bounds
    }
}

















