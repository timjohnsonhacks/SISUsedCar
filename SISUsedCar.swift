//
//  SISUsedCar.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import Foundation

class SISUsedCar {
    
    let id: Int
    let slug: String
    let userId: Int
    let year: String
    let make: String
    let model: String
    let trim: String
    let bodyStyle: String
    let price: Int
    let description: String
    let transmission: String
    let engine: String
    let mileage: Int
    let exteriorColor: String
    let driveTrain_1: String
    let driveTrain_2: String
    let vin: String
    let videoUrl: String
    let interiorColor: String
    let wheelBase: String
    let doorCount: Int
    let fuelType: String
    let isUsed: Bool
    let isSold: Bool
    let isDeleted: Bool
    let createdAt: String
    let updatedAt: String
    let stockNumber: String
    
    let images: [SISUsedCarImage]
    
    var shortDescription: String {
        return "\(year) \(make) \(model), price: \(price), mileage: \(mileage), id: \(id) stock number: \(stockNumber)"
    }
    
    init(id: Int, slug: String, userId: Int, year: String, make: String, model: String, trim: String, bodyStyle: String, price: Int, description: String, transmission: String, engine: String, mileage: Int, exteriorColor: String, driveTrain_1: String, driveTrain_2: String, vin: String, videoUrl: String, interiorColor: String, wheelBase: String, doorCount: Int, fuelType: String, isUsed: Bool, isSold: Bool, isDeleted: Bool, createdAt: String, updatedAt: String, stockNumber: String, images: [SISUsedCarImage]) {
        
        self.id = id
        self.slug = slug
        self.userId = userId
        self.year = year
        self.make = make
        self.model = model
        self.trim = trim
        self.bodyStyle = bodyStyle
        self.price = price
        self.description = description
        self.transmission = transmission
        self.engine = engine
        self.mileage = mileage
        self.exteriorColor = exteriorColor
        self.driveTrain_1 = driveTrain_1
        self.driveTrain_2 = driveTrain_2
        self.vin = vin
        self.videoUrl = videoUrl
        self.interiorColor = interiorColor
        self.wheelBase = wheelBase
        self.doorCount = doorCount
        self.fuelType = fuelType
        self.isUsed = isUsed
        self.isSold = isSold
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.stockNumber = stockNumber
        
        self.images = images
    }
}


