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
    
    @IBOutlet weak var tableView: UITableView!
    
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
                print("content count: \(self.content.count) \nmapping count: \(self.mapping.count)")
                print(self.mapping)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.fetchAllMainImages()
            }
        })
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
}

extension SISUsedCarVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SISUsedCarTVCell
        cell.resetImageView()
        
        let car = content[indexPath.row]
        let yearMakeModel = "\(car.year) \(car.make) \(car.model)"
        
        cell.configure(
            yearMakeModel: yearMakeModel,
            isSold: car.isSold ? "Sold" : "Available",
            price: "$$$ " + (String(car.price)))
        
        if let mainImage = car.images.first {
            if let mainImage = mainImage.image {
                cell.configure(image: mainImage)
            } else if mainImage.downloadAttemptFailed == false {
                cell.showActivityIndicator()
            } else if mainImage.downloadAttemptFailed == true {
                cell.showNoImageAvailable()
            }
        } else {
            cell.showNoImageAvailable()
        }
 
        return cell
    }
}

extension SISUsedCarVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
