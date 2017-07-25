//
//  SISUsedCarVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarVC: UIViewController {

    let cellID = "SISUsedCarTVCell"
    let dataService = SISUsedCarDataService()
    let imageService = SISUsedCarImageService()
    
    var content = [SISUsedCar]() {
        didSet {
            /* mapping depends on content, so configure mapping when content is set */
            var newMapping: [Int:IndexPath] = [:]
            var row: Int = 0
            for cont in content {
                let key: Int = cont.id
                let value = IndexPath(row: row, section: 0)
                newMapping[key] = value
                row += 1
            }
            mapping = newMapping
        }
    }
    var mapping: [Int : IndexPath] = [:] /*  usedCar.id : indexPath ; for cell updating */
    let itemsPerSection: Int = 5
    var activeContentIndex: Int = 0
    let searchPageButtonSize = CGSize(width: 30.0, height: 30.0)
    var selectedCar: SISUsedCar?
    var searchPageChildVc: SISSearchPageVC!
    
    var activeContentStartIndex: Int {
        return activeContentIndex * itemsPerSection
    }
    var activeContentEndIndex: Int {
        return (activeContentIndex + 1) * itemsPerSection - 1
    }
    var activeContent: [SISUsedCar] {
        return Array(content[activeContentStartIndex...activeContentEndIndex])
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchPageContainer: UIView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // vc config
        title = "Used Cars"
        
        // table view configuration
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "SISUsedCarTVCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellID)
        
        // initial car download
        getAll()
    }
    
    func getAll() {
        dataService.GET_all(completion: { (cars, _) in
            
            if let cars = cars {
                self.content = cars

                DispatchQueue.main.async {
                    self.setupSearchPageStackTableFooter()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func setupSearchPageStackTableFooter() {
        // add search page vc's view to footer
        searchPageChildVc = SISSearchPageVC(
            totalItemCount: content.count,
            itemsPerSection: itemsPerSection,
            buttonSize: searchPageButtonSize)
        addChildViewController(searchPageChildVc)
        searchPageContainer.addBoundsFillingSubview(searchPageChildVc.view)
        searchPageChildVc.didMove(toParentViewController: self)
    }
    
    func getMainImageForCar(_ car: SISUsedCar) {
        guard let ip = mapping[car.id] else {
            return
        }
        let userInfo: [String:Any] = ["indexPath" : ip]
        
        imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { (success, userInfo) in
            guard let ip = userInfo["indexPath"] as? IndexPath else {
                return
            }
            
            if self.isActiveIndexPath(ip) == true {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [ip], with: .none)
                }
            }
 
            if success == false {
                print("image download not successful for car: \(car.shortDescription)")
                if let mainImageUrl = car.images.first?.fullPath {
                    print("main image path: \(mainImageUrl)")
                } else {
                    print("no main image url")
                }
            }
        })
    }
    
    func isActiveIndexPath(_ ip: IndexPath) -> Bool {
        return ip.row >= activeContentStartIndex && ip.row <= activeContentEndIndex
    }
    
    func fetchAllMainImages() {
        for car in content {
            guard let ip = mapping[car.id] else {
                continue
            }
            let userInfo: [String:Any] = ["indexPath" : ip]
            
            imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { (success, userInfo) in
                guard let ip = userInfo["indexPath"] as? IndexPath else {
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [ip], with: .none)
                }
                if success == false {
                    print("image download not successful for car: \(car.shortDescription)")
                    if let mainImageUrl = car.images.first?.fullPath {
                        print("main image path: \(mainImageUrl)")
                    } else {
                        print("no main image url")
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! SISUsedCarDetailVC
            detailVC.usedCar = selectedCar!
        }
    }
}

// MARK: - Table View Data Source

extension SISUsedCarVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // make sure there is a full section to return. If not, return the partial count
        if activeContentIndex * (itemsPerSection + 1) < content.count {
            return itemsPerSection
        } else {
            return content.count - activeContentIndex * itemsPerSection
        }
    }
    
    func mapIndexPath(_ ip: IndexPath) -> SISUsedCar {
        let currentRow = ip.row
        let correctedRow = activeContentIndex * itemsPerSection + currentRow
        return content[correctedRow]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SISUsedCarTVCell
        cell.resetImageView()
        
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
                getMainImageForCar(car)
            } else if mainImage.downloadAttemptFailed == true {
                cell.showNoImageAvailable()
            }
        } else {
            cell.showNoImageAvailable()
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
        selectedCar = content[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}
