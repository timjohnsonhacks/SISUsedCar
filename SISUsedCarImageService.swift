//
//  SISUsedCarImageService.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let didDownloadMainImage = Notification.Name("did download main image")
    static let didDownloadSupplementaryImage = Notification.Name("did download supplementary image")
}

public class SISUsedCarImageService {
    
    enum InfoKeys: String {
        case success, usedCar, imageIndex, userInfo, image
    }
    
    private let session = URLSession(configuration: .default)
    
    public func GET_mainImage(forUsedCar usedCar: SISUsedCar, userInfo: [String:Any], completion: @escaping([String:Any]) -> Void ) {
        GET_image(
            forUsedCar: usedCar,
            imageIndex: 0,
            userInfo: userInfo,
            completion: completion)
    }
    
    public func GET_allImages(forUsedCar usedCar: SISUsedCar, userInfo: [String:Any], completion: @escaping ([String : Any]) -> Void) {
        for (index, imageContainer) in usedCar.images.enumerated() {
            if imageContainer.image == nil {
                GET_image(
                    forUsedCar: usedCar,
                    imageIndex: index,
                    userInfo: userInfo,
                    completion: completion
                )
            }
        }
    }
    
    public func GET_image(forUsedCar usedCar: SISUsedCar, imageIndex: Int, userInfo: [String:Any], completion: @escaping([String : Any]) -> Void) {
        /* downloads the image at the specified index and sets on passed-in used car. Returns dictionary of info for use by client. Executes completion block and posts notification to default center */
        // make sure passed in index is a valid image index
        let limit = usedCar.images.count
        guard imageIndex < limit && imageIndex >= 0 else {
            return
        }
        
        let imageContainer = usedCar.images[imageIndex]
        guard let url = URL(string: imageContainer.fullPath) else {
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            var returnDict: [String:Any] = [InfoKeys.userInfo.rawValue : userInfo,
                                            InfoKeys.usedCar.rawValue : usedCar,
                                            InfoKeys.imageIndex.rawValue : imageIndex]
            
            if let data = data, let image = UIImage(data: data) {
                imageContainer.image = image
                imageContainer.downloadAttemptFailed = false
                returnDict[InfoKeys.image.rawValue] = image
                returnDict[InfoKeys.success.rawValue] = true
                
            } else {
                imageContainer.downloadAttemptFailed = true
                returnDict[InfoKeys.success.rawValue] = false
            }
            
            // notifications
            if imageIndex == 0 {
                NotificationCenter.default.post(
                    name: Notification.Name.didDownloadMainImage,
                    object: usedCar,
                    userInfo: returnDict)
            } else {
                NotificationCenter.default.post(
                    name: Notification.Name.didDownloadSupplementaryImage,
                    object: usedCar,
                    userInfo: returnDict)
            }
  
            // completion
            completion(returnDict)
        })
    
        task.resume()
    }
}
















