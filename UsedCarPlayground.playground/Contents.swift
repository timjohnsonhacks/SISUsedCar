//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import IntegratedPlaygroundFiles

PlaygroundPage.current.needsIndefiniteExecution

let service = SISUsedCarDataService()
service.GET_all(completion: { cars, error in
    if let cars = cars {
        let car = cars[0]
        print(car.shortDescription)
    }
    PlaygroundPage.current.finishExecution()
})



