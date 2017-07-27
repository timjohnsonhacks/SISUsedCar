//
//  SISDownloadImageView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/27/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDownloadImageView: UIView {

    var imageView: UIImageView
    var activityView: UIActivityIndicatorView
    var errorLabel: UILabel
    
    
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        errorLabel = UILabel(frame: .zero)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageView = UIImageView(frame: .zero)
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        errorLabel = UILabel(frame: .zero)
        super.init(coder: aDecoder)
    }

}
