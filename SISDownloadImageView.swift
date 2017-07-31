//
//  SISDownloadImageView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/27/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDownloadImageView: UIView {

    private var imageView: UIImageView!
    private var activityView: UIActivityIndicatorView!
    private var errorLabel: UILabel!
    
    private var views: [UIView] {
        return [imageView, activityView, errorLabel]
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFit
        
        let av = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        av.hidesWhenStopped = true
        av.startAnimating()
        
        let el = UILabel(frame: .zero)
        el.text = "No Image Available"
        el.textColor = UIColor.white
        el.font = UIFont.boldSystemFont(ofSize: 20.0)
        el.numberOfLines = 0
        el.lineBreakMode = .byWordWrapping
        el.textAlignment = .center

        for v in [iv, av, el] {
            addBoundsFillingSubview(v)
        }
        
        self.activityView = av
        self.imageView = iv
        self.errorLabel = el
        
        activityView.startAnimating()
        imageView.isHidden = true
        errorLabel.isHidden = true
    }

    public func configureImage(_ image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        activityView.stopAnimating()
        errorLabel.isHidden = true
    }
    
    public func showNoImageAvailable() {
        errorLabel.isHidden = false
        activityView.stopAnimating()
        imageView.isHidden = true
    }
    
    public func showActivityIndicator() {
        activityView.startAnimating()
        imageView.isHidden = true
        errorLabel.isHidden = true
    }
    
    public func reset() {
        imageView.image = nil
        showActivityIndicator()
    }
}












