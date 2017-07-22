//
//  SISUsedCarDetailVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailVC: UIViewController {

    @IBOutlet weak var detailImagesContainerView: UIView!
    @IBOutlet weak var detailTextContainerView: UIView!
    @IBOutlet weak var yearMakeModel: UILabel!
    @IBOutlet weak var isAvailableLabel: UILabel!
    
    weak var detailImagesChild: SISDetailImagesVC!
    var usedCar: SISUsedCar!
    
    var detailItems: [(String, String)] {
        return [("price:", "$" + usedCar.price.commaDelimitedRepresentation()),
                ("mileage:", usedCar.mileage.commaDelimitedRepresentation()),
                ("body style:", "really really really long string to test cause I like really really really long strings"),
                ("engine:", usedCar.engine),
                ("transmission:", usedCar.transmission),
                ("drive train:", usedCar.driveTrain_1),
                ("exterior:", usedCar.exteriorColor),
                ("interior:", usedCar.interiorColor),
                ("doors:", String(usedCar.doorCount)),
                ("stock #:", usedCar.stockNumber),
                ("vin #:", usedCar.vin),
                ("fuel type:", usedCar.fuelType),
                ("condition:", "default"),
                ("owners:", "default")]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure vc text
        yearMakeModel.text = "\(usedCar.year) \(usedCar.make) \(usedCar.model)"
        isAvailableLabel.text = usedCar.isSold == false ? "   Available   " : "   Sold   "
        
        // add detail images vc child
        let detailImagesVc = SISDetailImagesVC(usedCar: usedCar)
        addChildViewController(detailImagesVc)
        detailImagesContainerView.addBoundsFillingSubview(detailImagesVc.view)
        detailImagesVc.didMove(toParentViewController: self)
        
        // detail text
        detailTextContainerView.insertWidthFillingStackedViews(detailTextView(), height: 40.0)
    }
    
    func detailTextView() -> [UIView] {
        var attributeViews = [UIView]()
        for (name, value) in detailItems {
            attributeViews.append(attributeView(name: name, value: value))
        }
        return attributeViews
    }
    
    func attributeView(name: String, value: String) -> UIView {
        let view = UIView()
        let nameLabel = UILabel()
        let valueLabel = UILabel()
        
        let units = [(nameLabel, "name"), (valueLabel, "value")]
        for (label, id) in units {
            view.addSubview(label)
            
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 17.0)
            label.textColor = UIColor.black
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[\(id)]-0-|", options: [], metrics: nil, views: [id : label]))
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[name(==value)]-10-[value]-0-|", options: [], metrics: nil, views: ["name" : nameLabel, "value" : valueLabel]))
        
        nameLabel.text = name
        valueLabel.text = value
        
        return view
    }
}


