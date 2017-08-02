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
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var featuresTitle: UILabel!
    @IBOutlet weak var specificationsTitle: UILabel!
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func configure(usedCar: SISUsedCar) {
        let carDetail = usedCar.detail
        // description
        let descriptionLabel = SISCustomLabel(frame: .zero)
        descriptionLabel.text = carDetail.text
        insertArrangedSubview(descriptionLabel, belowTitle: descriptionTitle)
        
        // features
        let featureCount = carDetail.features.count
        var first: String?
        var second: String?
        var featureViews = [UIView]()
        for (i, feature) in carDetail.features.enumerated() {
            if i % 2 == 0 {
                first = feature
            } else {
                second = feature
            }
            if i % 2 == 1 || i == featureCount - 1 {
                let checkPair = SISCheckPairLabel(frame: .zero)
                checkPair.configure(leftText: first, rightText: second)
                featureViews.append(checkPair)
                first = nil
                second = nil
            }
        }
        if featureViews.count > 0 {
            let featuresStack = UIStackView(arrangedSubviews: featureViews)
            featuresStack.axis = .vertical
            featuresStack.backgroundColor = .clear
            insertArrangedSubview(featuresStack, belowTitle: featuresTitle)
        }

        // attributes
        let detailStack = UIStackView(arrangedSubviews: detailTextViews(usedCar: usedCar))
        detailStack.axis = .vertical
        detailStack.backgroundColor = .clear
        insertArrangedSubview(detailStack, belowTitle: specificationsTitle)
    }
    
    private func insertArrangedSubview(_ subview: UIView, belowTitle title: UILabel) {
        var index = 0
        for v in contentStack.arrangedSubviews {
            if v === title {
                contentStack.insertArrangedSubview(subview, at: index + 1)
            }
            index += 1
        }
    }
    
    private func detailTextViews(usedCar: SISUsedCar) -> [UIView] {
        var attributeViews = [UIView]()
        for (name, value) in detailItems(usedCar: usedCar) {
            let av = UINib(nibName: "SISFeatureLabel", bundle: nil).instantiate(withOwner: self, options: nil).first! as! SISFeatureLabel
            av.nameLabel.text = name
            av.valueLabel.text = value
            attributeViews.append(av)
        }
        return attributeViews
    }
    
    private func detailItems(usedCar: SISUsedCar) -> [(String, String)] {
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
}







