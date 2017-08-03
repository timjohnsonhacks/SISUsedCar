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
            return numberOfRows(
                forPageIndex: filteredContentActivePage,
                itemsPerPage: filteredContentItemsPerPage,
                totalItemCount: filteredContent.count)
            
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
        cell.reset()
     
        let car: SISUsedCar
        switch searchController.isActive {
        case true:
            // filtered search
            let index = mappedIndex(
                forPageIndex: filteredContentActivePage,
                itemsPerPage: filteredContentItemsPerPage,
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

            /*
            * Instead of calling configure with yearMakeModel, isSold, price, and mileage, its better for the cell
            * to just have a `car` property, and upon setting that `car` property, setting up all the UI as needed. Then,
            * if the UI of the cell needs to change, the interface doesn't necessarily need to change. You can essentially
            * move all of the below logic to the cell and out of the ViewController. This is a more modular approach, 
            * allows for testability, and is cleaner.
            */
            cell.configure(
                yearMakeModel: car.yearMakeModel,
                isSold: car.isSold,
                price: "$ " + car.price.commaDelimitedRepresentation(),
                mileage: car.mileage.commaDelimitedRepresentation())
        }
        
        cell.configureNotificationsForCar(usedCar: car)

        /* if there is an image, show it. If the download has not yet been attempted, attempt it. If the download has already been attempted and failed, show the error view in the cell */
        guard let container = car.images.first else {
            cell.showNoImageAvailable()
            return cell
        }
        
        if let mainImage = container.image {
            cell.configureImage(mainImage)
            
        } else {
            if container.downloadAttemptFailed == false {
                cell.showActivityIndicator()
                getMainImageForCar(car)
                
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
        let car: SISUsedCar
        switch searchController.isActive {
        case true:
            // filtered search
            let index = mappedIndex(
                forPageIndex: filteredContentActivePage,
                itemsPerPage: filteredContentItemsPerPage,
                indexPath: indexPath)
            car = filteredContent[index].car
            
        case false:
            // general, unfiltered search
            let index = mappedIndex(
                forPageIndex: allContentActivePage,
                itemsPerPage: allContentItemsPerPage,
                indexPath: indexPath)
            car = allContent[index]
        }
        
        searchController.isActive = false
        let detailVC = SISUsedCarDetailMasterVC(usedCar: car)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}










