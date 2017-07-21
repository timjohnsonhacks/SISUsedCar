//
//  Int+Custom.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/21/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import Foundation

extension Int {
    
    func commaDelimitedRepresentation() -> String {
        var remaining = self
        var units = [String]()
        if remaining == 0 { return "0" }
        while remaining > 0 {
            let current = remaining % 1000
            units.append(String(current))
            remaining = remaining / 1000
        }
        var string = String()
        var isFirst = true
        while let current = units.popLast() {
            var correctedCurrent = current
            if isFirst == false {
                while correctedCurrent.characters.count < 3 {
                    correctedCurrent = "0" + correctedCurrent
                }
            }
            isFirst = false
            
            if units.count > 0 {
                correctedCurrent = correctedCurrent + ","
            }
            
            string.append(correctedCurrent)
        }
        return string
    }
}
