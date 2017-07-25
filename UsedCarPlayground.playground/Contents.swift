//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

import IntegratedPlaygroundFiles

let original: [Int] = [1,2,3]
let transformed = original.map( {
    return IndexPath(row: $0, section: 0)
})
transformed



