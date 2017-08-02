//
//  SISDetailTextView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/23/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDetailTextView: UIView {
    
    @IBOutlet weak var contentStack: UIStackView!
    
    private var usedCar: SISUsedCar!
    
    var detailItems: [(String, String)] {
        return [("price:", "$" + usedCar.price.commaDelimitedRepresentation()),
                ("mileage:", usedCar.mileage.commaDelimitedRepresentation()),
                ("body style:", usedCar.bodyStyle),
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
        
        for v in detailTextViews() {
            contentStack.addArrangedSubview(v)
        }
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
        let inset: CGFloat = 8.0
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
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
}







