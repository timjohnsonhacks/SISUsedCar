//
//  SISUsedCarDataService.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import Foundation

class SISUsedCarDataService {
    /*
     Class is designed to only run a single request at a time, cancelling the active task before beginning a new one
     */
    
    let session = URLSession(configuration: .default)
    
    var task: URLSessionDataTask?
    var predicate: String?
    var results: [SISUsedCar]?
    var errorMessage: String?
    
    func getAll(completion: @escaping ([SISUsedCar]?, String?) -> Void) {
        
        guard let url = URL(string: "https://southernimportspecialist.com/api/") else {
            return
        }
        
        task?.cancel()
        predicate = nil
        results = nil
        errorMessage = nil
        
        let currentTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let data = data,
                let jsonObjects = try? JSONSerialization.jsonObject(with: data, options: []),
                let dictArray = jsonObjects as? [[String:Any]] {
                
                var cars = [SISUsedCar]()
                for dict in dictArray {
                    
                    guard let id = dict["id"] as? Int,
                        let slug = dict["slug"] as? String,
                        let userId = dict["user_id"] as? Int,
                        let year = dict["year"] as? String,
                        let make = dict["make"] as? String,
                        let model = dict["model"] as? String,
                        let trim = dict["trim"] as? String,
                        let bodyStyle = dict["body_style"] as? String,
                        let price = dict["price"] as? Int,
                        let description = dict["description"] as? String,
                        let transmission = dict["transmission"] as? String,
                        let engine = dict["engine"] as? String,
                        let mileage = dict["mileage"] as? Int,
                        let exteriorColor = dict["exterior_color"] as? String,
                        let driveTrain_1 = dict["drive_train1"] as? String,
                        let driveTrain_2 = dict["drive_train2"] as? String,
                        let vin = dict["vin"] as? String,
                        let videoUrl = dict["video_url"] as? String,
                        let interiorColor = dict["interior_color"] as? String,
                        let wheelBase = dict["wheel_base"] as? String,
                        let doorCount = dict["door_count"] as? Int,
                        let fuelType = dict["fuel_type"] as? String,
                        let isUsed = dict["is_used"] as? Bool,
                        let isSold = dict["is_sold"] as? Bool,
                        let isDeleted = dict["is_deleted"] as? Bool,
                        let createdAt = dict["created_at"] as? String,
                        let updatedAt = dict["updated_at"] as? String,
                        let stockNumber = dict["stock_no"] as? String else {
                            self.errorMessage = "invalid json keys"
                            continue
                    }
                    
                    guard let images = dict["images"] as? [[String:Any]] else {
                        self.errorMessage = "invalid json 'images' key"
                        continue
                    }
                    
                    let baseImagePath = "https://southernimportspecialist.com/uploads/"
                    /* could specify an initial array length based on the number of images and then place images in array occording to orderId */
                    var usedCarImages = [SISUsedCarImage]()
                    
                    
                    for image in images {
                        guard let path = image["path"] as? String,
                            let orderId = image["order_id"] as? Int else {
                            self.errorMessage = "invalid json 'path' key"
                            continue
                        }
                        let fullPath = baseImagePath + path
                        let usedCarImage = SISUsedCarImage(fullPath: fullPath, orderId: orderId)
                        usedCarImages.append(usedCarImage)
                    }
                        
                    let uc = SISUsedCar(id: id,
                                        slug: slug,
                                        userId: userId,
                                        year: year,
                                        make: make,
                                        model: model,
                                        trim: trim,
                                        bodyStyle: bodyStyle,
                                        price: price,
                                        description: description,
                                        transmission: transmission,
                                        engine: engine,
                                        mileage: mileage,
                                        exteriorColor: exteriorColor,
                                        driveTrain_1: driveTrain_1,
                                        driveTrain_2: driveTrain_2,
                                        vin: vin,
                                        videoUrl: videoUrl,
                                        interiorColor: interiorColor,
                                        wheelBase: wheelBase,
                                        doorCount: doorCount,
                                        fuelType: fuelType,
                                        isUsed: isUsed,
                                        isSold: isSold,
                                        isDeleted: isDeleted,
                                        createdAt: createdAt,
                                        updatedAt: updatedAt,
                                        stockNumber: stockNumber,
                                        images: usedCarImages)
                    
                    cars.append(uc)
                }
                self.results = cars
            }
            completion(self.results, self.errorMessage)
        })
        
        currentTask.resume()
        task = currentTask
    }
}
