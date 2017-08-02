//
//  SISUsedCar.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import Foundation

let defaultString = "default"
let defaultInt = -1

public class SISUsedCar: NSObject {
    
    public var id: Int = defaultInt
    public var slug: String = defaultString
    public var userId: Int = defaultInt
    public var year: String = defaultString
    public var make: String = defaultString
    public var model: String = defaultString
    public var trim: String = defaultString
    public var bodyStyle: String = defaultString
    public var price: Int = defaultInt
    public var longDescription: String = defaultString
    public var transmission: String = defaultString
    public var engine: String = defaultString
    public var mileage: Int = defaultInt
    public var exteriorColor: String = defaultString
    public var driveTrain_1: String = defaultString
    public var driveTrain_2: String = defaultString
    public var vin: String = defaultString
    public var videoUrl: String = defaultString
    public var interiorColor: String = defaultString
    public var wheelBase: String = defaultString
    public var doorCount: Int = defaultInt
    public var fuelType: String = defaultString
    public var isUsed: Bool = false
    public var isSold: Bool = false
    public var isDeleted: Bool = false
    public var createdAt: String = defaultString
    public var updatedAt: String = defaultString
    public var stockNumber: String = defaultString
    
    public let images: [SISUsedCarImage]
    
    public var shortDescription: String {
        return "\(year) \(make) \(model), price: \(price), mileage: \(mileage), id: \(id) stock number: \(stockNumber)"
    }
    
    public var detail: (fullName: String?, features: [String], text: String?) {
        return matches(description: description)
    }
    
    var yearMakeModel: String {
        return "\(year) \(make) \(model)"
    }
    
    public init(images: [SISUsedCarImage]) {
        self.images = images
    }
    
    public init(id: Int, slug: String, userId: Int, year: String, make: String, model: String, trim: String, bodyStyle: String, price: Int, description: String, transmission: String, engine: String, mileage: Int, exteriorColor: String, driveTrain_1: String, driveTrain_2: String, vin: String, videoUrl: String, interiorColor: String, wheelBase: String, doorCount: Int, fuelType: String, isUsed: Bool, isSold: Bool, isDeleted: Bool, createdAt: String, updatedAt: String, stockNumber: String, images: [SISUsedCarImage]) {
        
        self.id = id
        self.slug = slug
        self.userId = userId
        self.year = year
        self.make = make
        self.model = model
        self.trim = trim
        self.bodyStyle = bodyStyle
        self.price = price
        self.longDescription = description
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
    
    // MARK: - String Parsing
    
    private func matches(description: String) -> (fullName: String?, features: [String], text: String?) {
        var startIndex: String.Index = description.startIndex
        var endIndex: String.Index = description.startIndex
        
        var fullName: String?
        while fullName == nil && endIndex < description.endIndex {
            if let nextStart = subMatch(fullString: description, startIndex: endIndex, matchPhrase: " - ") {
                fullName = description.substring(with: startIndex..<endIndex)
                startIndex = nextStart
                endIndex = nextStart
            } else {
                endIndex = description.index(after: endIndex)
            }
        }
        
        var features = [String]()
        var text: String?
        while endIndex < description.endIndex {
            if let nextStart = subMatch(fullString: description, startIndex: endIndex, matchPhrase: " . ") {
                text = description.substring(with: nextStart..<description.endIndex)
                break
            }
            
            if let nextStart = subMatch(fullString: description, startIndex: endIndex, matchPhrase: ", ") {
                let feature = description.substring(with: startIndex..<endIndex)
                features.append(feature)
                startIndex = nextStart
                endIndex = nextStart
            } else {
                endIndex = description.index(after: endIndex)
            }
        }
        
        
        return (fullName, features, text)
    }
    
    private func subMatch(fullString: String, startIndex: String.Index, matchPhrase: String) -> String.Index? {
        let offsetIndex = fullString.index(startIndex, offsetBy: matchPhrase.characters.count)
        guard offsetIndex < fullString.endIndex else {
            return nil
        }
        let range = startIndex..<offsetIndex
        if description.substring(with: range) == matchPhrase {
            return offsetIndex
        } else {
            return nil
        }
    }
}


