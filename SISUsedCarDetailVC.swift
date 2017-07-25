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
    @IBOutlet weak var textToCarConstraint: NSLayoutConstraint!
    
    weak var detailImagesChild: SISDetailImagesVC!
    weak var detailTextScrollView: SISDetailTextView!
    weak var fade: CAGradientLayer!
    var usedCar: SISUsedCar!
    var lastConstraint: NSLayoutConstraint!
    var currentConstraint: NSLayoutConstraint!
    var detailTextIsCondensed: Bool = true
    var expandedConstraint: NSLayoutConstraint!
    
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
        detailImagesChild = detailImagesVc
        
//        // detail text
//        let detailTextSV = SISDetailTextView(usedCar: usedCar)
//        detailTextContainerView.addBoundsFillingSubview(detailTextSV)
//        detailTextSV.isScrollEnabled = false
//        detailTextSV.contentOffset = CGPoint(x: 0.0, y: 0.0)
//        detailTextScrollView = detailTextSV
//        
//        // setup constraints
//        expandedConstraint = NSLayoutConstraint(item: detailTextScrollView,
//                                                attribute: .top,
//                                                relatedBy: .equal,
//                                                toItem: detailImagesChild.view,
//                                                attribute: .top,
//                                                multiplier: 1.0,
//                                                constant: 0.0)
//        currentConstraint = textToCarConstraint
//        lastConstraint = expandedConstraint
//        
//        // tap GR
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDetailText(tap:)))
//        tap.numberOfTapsRequired = 1
//        tap.numberOfTouchesRequired = 1
//        detailTextSV.addGestureRecognizer(tap)
    }
    
//    func didTapDetailText(tap: UITapGestureRecognizer) {
//        toggleDetailTextState(toTextIsCondensed: !detailTextIsCondensed)
//    }
//    
//    func toggleDetailTextState(toTextIsCondensed: Bool) {
//        
//        NSLayoutConstraint.activate([lastConstraint])
//        NSLayoutConstraint.deactivate([currentConstraint])
//        let last = lastConstraint
//        lastConstraint = currentConstraint
//        currentConstraint = last
//        
//        if toTextIsCondensed == true {
//            
//            self.detailImagesContainerView.isHidden = false
//            
//            UIView.animateKeyframes(
//                withDuration: 1.0,
//                delay: 0.0,
//                options: [],
//                animations: {
//     
//                    UIView.addKeyframe(
//                        withRelativeStartTime: 0.0,
//                        relativeDuration: 0.7,
//                        animations: {
//                            self.detailTextScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
//                            self.view.layoutIfNeeded()
//                    })
//                
//                    UIView.addKeyframe(
//                        withRelativeStartTime: 0.6,
//                        relativeDuration: 0.4,
//                        animations: {
//                            self.detailTextScrollView.fade.startPoint = CGPoint(x: 0.5, y: 0.6)
//                            self.detailImagesContainerView.alpha = 1.0
//                    })
//            },
//                completion: { _ in
//                    self.detailTextScrollView.isScrollEnabled = false
//                    self.detailTextIsCondensed = true
//            })
//            
//        } else if toTextIsCondensed == false {
//            
//            self.detailTextScrollView.fade.startPoint = CGPoint(x: 0.5, y: 1.0)
//            
//            UIView.animateKeyframes(
//                withDuration: 1.0,
//                delay: 0.0,
//                options: [],
//                animations: {
//                    UIView.addKeyframe(
//                        withRelativeStartTime: 0.0,
//                        relativeDuration: 0.4,
//                        animations: {
//                            self.detailImagesContainerView.alpha = 0.0
//                    })
//                    
//                    UIView.addKeyframe(
//                        withRelativeStartTime: 0.3,
//                        relativeDuration: 0.7,
//                        animations: {
//                            self.detailTextScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
//                            self.view.layoutIfNeeded()
//                    })
//            },
//                completion: { _ in
//                    self.detailTextScrollView.isScrollEnabled = true
//                    self.detailImagesContainerView.isHidden = true
//                    self.detailTextIsCondensed = false
//            })
//            
//        }
//    }

}


