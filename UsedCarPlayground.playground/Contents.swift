//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import IntegratedPlaygroundFiles

let description = "2015 Nissan Sentra S – Gray exterior, Black interior, Auto, A/C, loaded, 4- Dr, a backup camera, heat seats, V4 (1.8 L), 2 WD, power windows, power mirrors, overhead airbag, rear defroster, ABS brakes, power lock. No matter your needs this vehicle will cope while keeping you comfortable. This vehicle has a FLAWLESS interior! Buy this car for $ 14,950 Cash or finance it with $ 3,500 down. For more information please call us at 601-939-9195."
let results = SISStringParser.matches(searchText: description)

print(results.text)
for f in results.features {
    print(f)
}
print(results.fullName)



