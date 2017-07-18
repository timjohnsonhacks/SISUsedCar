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
    
    var content = [SISUsedCarCellContent]()
    
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
                for c in cars {
                    let carCellContent = SISUsedCarCellContent(usedCar: c)
                    self.content.append(carCellContent)
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
        let car = content[indexPath.row].usedCar
        let yearMakeModel = "\(car.year) \(car.make) \(car.model)"
        cell.configureText(
            yearMakeModel: yearMakeModel,
            isSold: car.isSold ? "Sold" : "Available",
            price: "$$$ " + (String(car.price)))
        
        return cell
    }
}

extension SISUsedCarVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
