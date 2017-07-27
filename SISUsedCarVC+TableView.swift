//
//  SISUsedCarVC+TableView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

// MARK: - Table View Data Source

extension SISUsedCarVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsForActiveContentIndex(activeContentIndex)
    }
    
    func mapIndexPath(_ ip: IndexPath) -> SISUsedCar {
        let currentRow = ip.row
        let correctedRow = activeContentIndex * itemsPerSection + currentRow
        return content[correctedRow]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SISUsedCarTVCell
        cell.resetImageView()
        
        switch searchController.isActive {
        case false:
            let car = mapIndexPath(indexPath)
            let yearMakeModel = "\(car.year) \(car.make) \(car.model)"
            
            cell.configure(
                yearMakeModel: yearMakeModel,
                isSold: car.isSold,
                price: "$ " + car.price.commaDelimitedRepresentation(),
                mileage: car.mileage.commaDelimitedRepresentation())
            
            if let mainImage = car.images.first {
                if let mainImage = mainImage.image {
                    
                    cell.configure(image: mainImage)
                    
                } else if mainImage.downloadAttemptFailed == false {
                    
                    cell.showActivityIndicator()
                    if shouldFetchImage == true {
                        getMainImageForCar(
                            car,
                            indexPath: indexPath,
                            requestContentIndex: activeContentIndex)
                    }
             
                } else if mainImage.downloadAttemptFailed == true {
                    
                    cell.showNoImageAvailable()
                    
                }
            } else {
                cell.showNoImageAvailable()
            }
            
        case true:
            let car = filteredContent[indexPath.row]
            
            cell.configureWithAttributedText(
                yearMakeModel: car.attributedString,
                isSold: car.car.isSold,
                price: "$ " + car.car.price.commaDelimitedRepresentation(),
                mileage: car.car.mileage.commaDelimitedRepresentation())
            
            if let mainImage = car.car.images.first {
                if let mainImage = mainImage.image {
                    cell.configure(image: mainImage)
                } else if mainImage.downloadAttemptFailed == false {
                    cell.showActivityIndicator()
                    if shouldFetchImage == true {
                        getMainImageForCar(
                            car.car,
                            indexPath: indexPath,
                            requestContentIndex: activeContentIndex)
                    }

                } else if mainImage.downloadAttemptFailed == true {
                    cell.showNoImageAvailable()
                }
            } else {
                cell.showNoImageAvailable()
            }
        }
        return cell
    }
}

// MARK: - Table View Delegate

extension SISUsedCarVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        searchPageChildVc.view.isHidden = false
        presentControllerForIndexPath(indexPath)
        
    }
    
    func presentControllerForIndexPath(_ indexPath: IndexPath) {
        let selectedCar = content[indexPath.row]
        let vc = SISUsedCarDetailMasterVC(usedCar: selectedCar)
        navigationController?.pushViewController(vc, animated: true)
    }
}










