//
//  SISUsedCarDetailVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailVC: UIViewController {
    
//    @IBOutlet weak var imageCollectin: UICollectionView!
    @IBOutlet weak var yearMakeModel: UILabel!
    
    var usedCar: SISUsedCar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearMakeModel.text = "\(usedCar.year) \(usedCar.make) \(usedCar.model)"
    }
    
}
