//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

import IntegratedPlaygroundFiles

// MARK: - Test Area
PlaygroundPage.current.needsIndefiniteExecution = true

let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
PlaygroundPage.current.liveView = view
var usedCars = [SISUsedCar]()
let dataService = SISUsedCarDataService()
let imageService = SISUsedCarImageService()
dataService.GET_all(completion: { (cars, error) in
    if let cars = cars {
        usedCars = cars
    }
    
    for car in usedCars {
        print(car.shortDescription)
    }
    
    if let firstCar = usedCars.first {
        var userInfo = [String:Any]()
        imageService.GET_allImages(forUsedCar: firstCar, userInfo: &userInfo, completion: { (success, userInfo) in
            print("success: \(success), user info: \(userInfo)")
            if let number = userInfo["order"] as? Int,
                number == 5 {
                view.image = firstCar.images[number - 1].image
            }
        })
    }
})
