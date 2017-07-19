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
}
