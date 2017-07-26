//
//  SISDetailTextView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/23/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDetailTextView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var attributesContainer: UIView!
    
    private var usedCar: SISUsedCar!
    
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
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(usedCar: SISUsedCar) {
        self.usedCar = usedCar
        
        // subview config
        descriptionLabel.text = usedCar.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 15.0)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        attributesContainer.insertWidthFillingStackedViews(detailTextViews(), height: 25.0)
    }
    
    private func detailTextViews() -> [UIView] {
        var attributeViews = [UIView]()
        for (name, value) in detailItems {
            attributeViews.append(attributeView(name: name, value: value))
        }
        return attributeViews
    }
    
    private func attributeView(name: String, value: String) -> UIView {
        let view = UIView()
        let insets = UIEdgeInsets(top: 3.0, left: 6.0, bottom: 3.0, right: 3.0)
        let nameLabel = SISCustomLabel(frame: .zero, insets: insets)
        let valueLabel = SISCustomLabel(frame: .zero, insets: insets)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        valueLabel.font = UIFont.systemFont(ofSize: 15)
        
        let units = [(nameLabel, "name"), (valueLabel, "value")]
        for (label, id) in units {
            view.addSubview(label)
            
            label.textAlignment = .left
            label.textColor = UIColor.black
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 0.5
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[\(id)]-0-|", options: [], metrics: nil, views: [id : label]))
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[name(==value)]-0-[value]-20-|", options: [], metrics: nil, views: ["name" : nameLabel, "value" : valueLabel]))
        
        nameLabel.text = name
        valueLabel.text = value
        
        return view
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        print("size passed to size that fits: \(size)")
        if let sv = superview {
//            print("super view size in sizeThatFits: \(sv.bounds.size)")
            frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: sv.bounds.size.width,
                height: 10000)
            layoutIfNeeded()
//            print("----- view frame: \(frame)")
//            print("upper subview frame: \(descriptionLabel.frame)")
//            print("lowest subview frame: \(attributesContainer.frame)")
            return CGSize(
                width: sv.bounds.size.width,
                height: attributesContainer.frame.origin.y + 600)
            
        }
        return super.sizeThatFits(size)
    }
}







