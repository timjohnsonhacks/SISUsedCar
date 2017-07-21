//
//  SISUsedCarDetailVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailVC: UIViewController {
    
    @IBOutlet weak var yearMakeModel: UILabel!
    @IBOutlet weak var detailImagesContainerView: UIView!
    
    weak var detailImagesChild: SISDetailImagesVC!
    var usedCar: SISUsedCar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure vc text
        yearMakeModel.text = "\(usedCar.year) \(usedCar.make) \(usedCar.model)"
        
        // add detail images vc child
        let detailImagesVc = SISDetailImagesVC(usedCar: usedCar)
        addChildViewController(detailImagesVc)
        detailImagesContainerView.addBoundsFillingSubview(detailImagesVc.view)
        detailImagesVc.didMove(toParentViewController: self)
    }
    
}


