//
//  SISUsedCarVC+SearchController.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension SISUsedCarVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            filterContentForSearchText(text)
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        /* a new AccordianTableViewContentProtocol object will need to be created for every existing object in the current content array. If any detailTitle includes the search text, include it.  If any sectionTitle contains the search text OR any of its detailTitles contain the search text, include it  */
        
        /* WHEN NO SEARCH TEXT HAS BEEN ENTERED, THE FILTERED CONTENT SHOULD CONTAIN THE COMBINED NAMES IN ALPHABETICAL ORDER */
        
        var filteredCars = [FilteredCar]()
        for car in content {
            let searchWords = words(forText: searchText)
            let carName = car.yearMakeModel
            var attributedFullName = NSMutableAttributedString(string: carName)
            var score: Int = 0
            
            for word in searchWords {
                score += attributeString(
                    pattern: word,
                    originalString: carName,
                    attributedString: &attributedFullName,
                    attributes: highlightedAttributes)
            }
            
            if score > 0 {
                filteredCars.append((car, attributedFullName, score))
            }
            
        }
        
        filteredCars.sort(by: { (member1, member2) -> Bool in
            return member1.score > member2.score
        })
        filteredContent = filteredCars
        tableView.reloadData()
    }
    
    func words(forText text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: "\\w+\\b")
            let nsString = text as NSString
            let results: [NSTextCheckingResult] = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            var count: Int = 0
            _ = results.map {
                count += $0.range.length
            }
            return results.map {
                nsString.substring(with: $0.range)
            }
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func attributeString(pattern: String, originalString: String, attributedString: inout NSMutableAttributedString, attributes: [String : Any]) -> Int {
        
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: .caseInsensitive)
        let range = NSMakeRange(0, originalString.characters.count)
        
        if let matches = regex?.matches(
            in: originalString,
            options: [],
            range: range) {
            
            var count: Int = 0
            for match in matches {
                count += match.range.length
                
                attributedString.addAttributes(
                    attributes,
                    range: match.range)
            }
            
            return count
            
        } else {
            return 0
        }
    }
}
