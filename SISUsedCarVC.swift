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
    
    var content = [SISUsedCarCellContent]()
    var contentMapping: [String : IndexPath] = [:] // stockNumber : IndexPath for image setting upon asynchronous delivery
    
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
        dataService.getAll(completion: { (cars, error) in
            
            print("service executing completion block...")
            
            if let error = error {
                print(error)
            }
            
            if let cars = cars {
                
                self.content.removeAll()
                var index = 0
                for c in cars {
                    let carCellContent = SISUsedCarCellContent(usedCar: c, mainImage: nil)
                    self.content.append(carCellContent)
                    self.contentMapping[c.stockNumber] = IndexPath(row: index, section: 0)
                    index += 1
                    
//                    self.imageService.mainImage(forStockNumber: c.stockNumber, completion: { (stockNumber, mainImage) in
//                        if let path = self.contentMapping[stockNumber],
//                            let mainImage = mainImage {
//                            DispatchQueue.main.async {
//                                self.content[path.row].mainImage = mainImage
//                                self.tableView.reloadRows(at: [path], with: .none)
//                            }
//                        }
//                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
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
        let car = content[indexPath.row]
        let yearMakeModel = "\(car.usedCar.year) \(car.usedCar.make) \(car.usedCar.model)"
        
        cell.configure(
            yearMakeModel: yearMakeModel,
            isSold: car.usedCar.isSold ? "Sold" : "Available",
            price: "$$$ " + (String(car.usedCar.price)))
        
        // load the image or show the activity indicator
        if let mainImage = car.mainImage {
            cell.configure(image: mainImage)
        } else {
            cell.showActivityIndicator()
        }
        
        return cell
    }
}

extension SISUsedCarVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
