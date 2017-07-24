//
//  SISDetailTextView.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/23/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDetailTextView: UIScrollView {

    let usedCar: SISUsedCar
    var masterSubview: UIView!
    var fade: CAGradientLayer!
    
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
    
    init(usedCar: SISUsedCar) {
        self.usedCar = usedCar
        super.init(frame: .zero)
        
        // subview instantiation and layout
        masterSubview = UIView()
        let label = UILabel()
        let detailContainer = UIView()
        let mapping: [String : UIView] = ["label" : label,
                                       "detailC" : detailContainer]
        
        label.text = usedCar.description
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        detailContainer.insertWidthFillingStackedViews(detailTextViews(), height: 25.0)
        
        for (name, v) in mapping {
            masterSubview.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[\(name)]-0-|", options: [], metrics: nil, views: mapping))
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-10-[detailC]-0-|", options: [], metrics: nil, views: mapping))
        addSubview(masterSubview)
        
        // fade
        let f = CAGradientLayer()
        f.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        f.startPoint = CGPoint(x: 0.5, y: 0.6)
        f.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.mask = f
        fade = f
    }
    
    func detailTextViews() -> [UIView] {
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
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[name(==value)]-10-[value]-0-|", options: [], metrics: nil, views: ["name" : nameLabel, "value" : valueLabel]))
        
        nameLabel.text = name
        valueLabel.text = value
        
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // subviews
        masterSubview.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 800)
        contentSize = masterSubview.bounds.size
        
        // fade 
        fade.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
