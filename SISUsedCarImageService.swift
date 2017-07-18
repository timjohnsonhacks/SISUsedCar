//
//  SISUsedCarImageService.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarImageService {
    
    let session = URLSession(configuration: .default)
    
    func mainImage(forStockNumber stockNumber: String, completion: @escaping(String, UIImage?) -> Void) {
        
        imageUrls(forStockNumber: stockNumber, completion: { (stockNumber, mappedUrls) in
            
            if let mappedUrls = mappedUrls,
                let mainUrl = mappedUrls[1] {
                
                self.image(forUrl: mainUrl, completion: { mainImage in
                    completion(stockNumber, mainImage)
                })
            }
        })
    }
    
    private func imageUrls(forStockNumber stockNumber: String, completion: @escaping (String, [Int:URL]?) -> Void) {
        
        let urlString = "https://southernimportspecialist.com/api/image/" + stockNumber
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                completion(stockNumber, nil)
                return
            }
            
            guard let data = data,
                let jsonDict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any],
                let path = jsonDict["path"] as? String,
                let model = jsonDict["model"] as? [String:Any],
                let images = model["images"] as? [[String:Any]] else {
                    completion(stockNumber, nil)
                    return
            }
            var mappedUrls = [Int:URL]()
            for image in images {
                if let fileName = image["path"] as? String,
                    let orderId = image["order_id"] as? Int,
                    let url = URL(string: "https://southernimportspecialist.com" + path + fileName) {
                    
                    mappedUrls[orderId] = url
                }
            }
            completion(stockNumber, mappedUrls)
        })
        task.resume()
    }
    
    private func image(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("error: " + error.localizedDescription)
                return
            }
            
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            }
        })
        task.resume()
    }
}
