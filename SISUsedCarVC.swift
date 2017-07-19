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
    var duplicates: [String : [SISUsedCar]] = [:] // stockNumber : SISUsedCarCollection to find duplicate stock numbers
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func printImageStatus() {
        print("cars with no images...")
        for cont in content {
            if cont.mainImage == nil {
                print(cont.usedCar.shortDescription)
            }
        }
        print("content count \(content.count) mapping count: \(contentMapping.count)")
        
        print("listing duplicates...")
        for (stockNumber, cars) in duplicates {
            print("\(stockNumber) : \n\(cars[0]) \n\(cars[1])")
        }
    }
    
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
        dataService.getAll(completion: { (cars, _) in
            if let cars = cars {
                self.content.removeAll()
                var index = 0
                for c in cars {
                    let carCellContent = SISUsedCarCellContent(usedCar: c, mainImage: nil)
                    self.content.append(carCellContent)
                    
                    if let indexPath = self.contentMapping[c.stockNumber] {
                        print("found duplicate stock number")
                        let existingCar = self.content[indexPath.row].usedCar
                        self.duplicates[c.stockNumber] = [existingCar, c]
                    } else {
                        self.contentMapping[c.stockNumber] = IndexPath(row: index, section: 0)
                    }
                    index += 1
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.fetchMainImages()
            }
        })
    }
    
    func fetchMainImages() {
        
        for cont in content {
            guard cont.mainImage == nil else {
                continue
            }
            let stockNum = cont.usedCar.stockNumber
            
            self.imageService.mainImage(forStockNumber: stockNum, completion: { (stockNum, mainImage) in
                guard let indexPath = self.contentMapping[stockNum] else {
                    return
                }
                if let mainImage = mainImage {
                    DispatchQueue.main.async {
                        self.content[indexPath.row].mainImage = mainImage
                        self.tableView.reloadRows(at: [indexPath], with: .none)
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
