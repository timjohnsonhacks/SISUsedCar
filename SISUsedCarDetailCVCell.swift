//
//  SISUsedCarDetailCVCell.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailCVCell: UICollectionViewCell {
    
    weak var downloadImageView: SISDownloadImageView!
    private var imageIndex: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func commonInit() {
        /* create views programatically. Xib is useless because it gives you no access to the contentView, which is the superview for normally displayed content */
        let dv = SISDownloadImageView(frame: .zero)
        contentView.addBoundsFillingSubview(dv)
        downloadImageView = dv
        
        layoutMargins = .zero
    }
    
    func configureBorder(_ border: Bool) {
        switch border {
        case true:
            downloadImageView.layer.masksToBounds = true
            downloadImageView.layer.cornerRadius = 8.0
            downloadImageView.layer.borderColor = UIColor.darkGray.cgColor
            downloadImageView.layer.borderWidth = 2.0
            
        case false:
            downloadImageView.layer.masksToBounds = false
            downloadImageView.layer.cornerRadius = 0.0
            downloadImageView.layer.borderColor = UIColor.clear.cgColor
            downloadImageView.layer.borderWidth = 0.0
        }
    }
    
    public func configureImage(_ image: UIImage) {
        downloadImageView.configureImage(image)
    }
    
    public func showActivityIndicator() {
        downloadImageView.showActivityIndicator()
    }
    
    public func showNoImageAvailable() {
        downloadImageView.showNoImageAvailable()
    }
    
    public func reset() {
        downloadImageView.reset()
    }
    
    // MARK: - Notifications
    
    public func configureNotificationsForCar(usedCar: SISUsedCar, imageIndex: Int) {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDownloadSupplementaryImage(notification:)),
            name: Notification.Name.didDownloadSupplementaryImage,
            object: usedCar)
        self.imageIndex = imageIndex
    }
    
    @objc private func didDownloadSupplementaryImage(notification: Notification) {
        guard let info = notification.userInfo as? [String:Any],
            let notificationIndex = info[SISUsedCarImageService.InfoKeys.imageIndex.rawValue] as? Int else {
                return
        }
        
        if notificationIndex == imageIndex {
            if let image = info[SISUsedCarImageService.InfoKeys.image.rawValue] as? UIImage {
                DispatchQueue.main.async {
                    self.configureImage(image)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showNoImageAvailable()
                }

            }
        }
    }
}










