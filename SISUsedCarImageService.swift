//
//  SISUsedCarImageService.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

public class SISUsedCarImageService {
    
    public let session = URLSession(configuration: .default)
    
    public init() {}
    
    public func GET_mainImage(forUsedCar usedCar: SISUsedCar, userInfo: [String:Any], completion: @escaping(Bool, [String:Any]) -> Void ) {
        /* downloads main image and sets appropriate image on passed-in used car. Returns success and passed-in user info. Clients should provide user info to satisfy their own mapping needs */
        guard let string = usedCar.images.first?.fullPath,
            let url = URL(string: string) else {
                completion(false, userInfo)
                return
        }
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                
                usedCar.images.first?.image = image
                usedCar.images.first?.downloadAttemptFailed = false
                completion(true, userInfo)
                return
            } else {
                usedCar.images.first?.downloadAttemptFailed = true
                completion(false, userInfo)
                return
            }
        })
        task.resume()
    }
    
    public func GET_allImages(forUsedCar usedCar: SISUsedCar, userInfo: inout [String:Any], completion: @escaping (Bool, [String:Any]) -> Void) {
        /* downloads all images that are not already downloaded and configures in passed-in used car. Returns passed-in user info and errors if exists. Clients should provide user info to satisfy their own mapping needs */
        var index = 0
        for imageContainer in usedCar.images {
            userInfo["order"] = index
            if imageContainer.image == nil {
            
                GET_image(forUsedCar: usedCar, imageIndex: index, userInfo: userInfo, completion: { (success, userInfo) in
                    completion(success, userInfo)
                })
            }
            index += 1
        }
    }
    
    public func GET_image(forUsedCar usedCar: SISUsedCar, imageIndex: Int, userInfo: [String:Any], completion: @escaping(Bool, [String:Any]) -> Void) {
        /* downloads the image at the specified index and sets on passed-in used car. Returns success and passed-in user info. Clients should provide user info to satisfy their own mapping needs */
        let limit = usedCar.images.count
        guard imageIndex < limit && imageIndex >= 0 else {
            return
        }
        let imageContainer = usedCar.images[imageIndex]
        guard let url = URL(string: imageContainer.fullPath) else {
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                
                imageContainer.image = image
                imageContainer.downloadAttemptFailed = false
                completion(true, userInfo)
                return
            } else {
                imageContainer.downloadAttemptFailed = true
                completion(false, userInfo)
                return
            }
        })
        task.resume()
    }
}
















