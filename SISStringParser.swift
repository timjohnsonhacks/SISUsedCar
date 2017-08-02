//
//  SISStringParser.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 8/2/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import Foundation

public class SISStringParser {
    
    public static func matches(searchText: String) -> (fullName: String?, features: [String], text: String?) {
        print("search text: \(searchText)")
        var startIndex: String.Index = searchText.startIndex
        var endIndex: String.Index = searchText.startIndex
        
        var fullName: String?
        while fullName == nil && endIndex < searchText.endIndex {
            if let nextStart = subMatch(fullString: searchText, startIndex: endIndex, matchPhrase: " - ") {
                fullName = searchText.substring(with: startIndex..<endIndex)
                startIndex = nextStart
                endIndex = nextStart
            } else {
                endIndex = searchText.index(after: endIndex)
            }
        }
        
        var features = [String]()
        var text: String?
        while endIndex < searchText.endIndex {
            if let nextStart = subMatch(fullString: searchText, startIndex: endIndex, matchPhrase: ". ") {
                text = searchText.substring(with: nextStart..<searchText.endIndex)
                break
            }
            
            if let nextStart = subMatch(fullString: searchText, startIndex: endIndex, matchPhrase: ", ") {
                let feature = searchText.substring(with: startIndex..<endIndex)
                features.append(feature)
                startIndex = nextStart
                endIndex = nextStart
            } else {
                endIndex = searchText.index(after: endIndex)
            }
        }
        
        return (fullName, features, text)
    }
    
    private static func subMatch(fullString: String, startIndex: String.Index, matchPhrase: String) -> String.Index? {
        let guardIndex = fullString.index(fullString.endIndex, offsetBy: -1 * matchPhrase.characters.count)
        guard startIndex < guardIndex else {
            return nil
        }
        
        let offsetIndex = fullString.index(startIndex, offsetBy: matchPhrase.characters.count)
        let range = startIndex..<offsetIndex
        if fullString.substring(with: range) == matchPhrase {
            return offsetIndex
        } else {
            return nil
        }
    }
    
}
