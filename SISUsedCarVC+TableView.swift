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
        switch searchController.isActive {
        case true:
            // filtered search
            return filteredContent.count
            
        case false:
            // general, unfiltered search
            return numberOfRows(
                forPageIndex: allContentActivePage,
                itemsPerPage: allContentItemsPerPage,
                totalItemCount: allContent.count)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SISUsedCarTVCell
        cell.resetImageView()
 
        let car: SISUsedCar
        switch searchController.isActive {
        case true:
            // filtered search
            let index = mappedIndex(
                forPageIndex: filteredContentActivePage,
                itemsPerPage: filteredContent.count,
                indexPath: indexPath)
            let filteredCar = filteredContent[index]
            car = filteredCar.car
            
            cell.configureWithAttributedText(
                yearMakeModel: filteredCar.attributedString,
                isSold: car.isSold,
                price: "$ " + car.price.commaDelimitedRepresentation(),
                mileage: car.mileage.commaDelimitedRepresentation())
        
        case false:
            // general, unfiltered search
            let index = mappedIndex(
                forPageIndex: allContentActivePage,
                itemsPerPage: allContentItemsPerPage,
                indexPath: indexPath)
            car = allContent[index]

            cell.configure(
                yearMakeModel: car.yearMakeModel,
                isSold: car.isSold,
                price: "$ " + car.price.commaDelimitedRepresentation(),
                mileage: car.mileage.commaDelimitedRepresentation())
        }

        if let mainImage = car.images.first {
            if let mainImage = mainImage.image {
                cell.configure(image: mainImage)
                
            } else if mainImage.downloadAttemptFailed == false {
                cell.showActivityIndicator()
                getMainImageForCar(car)
            
            } else {
                cell.showNoImageAvailable()
            }
        }
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










