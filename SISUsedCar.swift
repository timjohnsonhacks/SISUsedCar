//
//  SISUsedCar.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import Foundation

struct SISUsedCar {
    
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
    
    var shortDescription: String {
        return "\(year) \(make)\(model), price: \(price), mileage: \(mileage), stock number: \(stockNumber)"
    }
}
