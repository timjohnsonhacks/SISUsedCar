//
//  SISUsedCarDetailImagesMasterVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

protocol DetailImagesMaster {
    func didSelectImage(indexPath: IndexPath)
}

protocol DependentDetailImages {
    func updateCollectionView(indexPath: IndexPath)
}

class SISUsedCarDetailMasterVC: UIViewController, DetailImagesMaster {
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var yearMakeModelLabel: UILabel!
    @IBOutlet weak var isSoldLabel: CustomIsSoldLabel!
    @IBOutlet weak var contactUsButton: UIButton!
    weak var gradient: SISGradientBackgroundView!
    weak var imageContainer: SISDetailImageLayoutView!
    weak var detailContainer: SISDetailTextView!
    
    let usedCar: SISUsedCar
    var largeImageChild: SISUsedCarDetailLargeImageVC!
    var smallImagesChild: SISUsedCarDetailSmallImagesVC!
    
    init(usedCar: SISUsedCar) {
        self.usedCar = usedCar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view config
        edgesForExtendedLayout = []
        
        let gl = CAGradientLayer()
        gl.startPoint = CGPoint(x: 0.0, y: 0.0)
        gl.endPoint = CGPoint(x: 1.0, y: 1.0)
        gl.colors = [UIColor.white.cgColor, UIColor.lightGray.cgColor]
        let gbv = SISGradientBackgroundView(frame: .zero, gradient: gl)
        view.addBoundsFillingSubview(gbv)
        view.sendSubview(toBack: gbv)
        gradient = gbv
        
        // image child vc's
        let largeImageVC = SISUsedCarDetailLargeImageVC(usedCar: usedCar)
        let smallImagesVC = SISUsedCarDetailSmallImagesVC(usedCar: usedCar, delegate: self)
        addChildViewController(largeImageVC)
        addChildViewController(smallImagesVC)
        
        let dynamicContainer = SISDetailImageLayoutView(
            frame: .zero,
            largeImageContainer: largeImageVC.view,
            smallImageContainer: smallImagesVC.view,
            aspectRatio: SISGlobalConstants.defaultAspectRatio,
            smallHeight: 80.0,
            largeSmallVerticalSpacing: 40.0)
        contentContainer.addBoundsFillingSubview(dynamicContainer)
        imageContainer = dynamicContainer
        
        largeImageVC.didMove(toParentViewController: self)
        smallImagesVC.didMove(toParentViewController: self)
        largeImageChild = largeImageVC
        smallImagesChild = smallImagesVC
        
        // detail text
        let dtc = UINib(nibName: "SISDetailTextView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! SISDetailTextView
        dtc.configure(usedCar: usedCar)
        contentContainer.addBoundsFillingSubview(dtc)
        detailContainer = dtc
        detailContainer.isHidden = true
        
        // basic label config
        yearMakeModelLabel.text = usedCar.yearMakeModel
        yearMakeModelLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        yearMakeModelLabel.textAlignment = .center
        
        isSoldLabel.isSold = usedCar.isSold
        isSoldLabel.font = UIFont.systemFont(ofSize: 20)
        
        contactUsButton.backgroundColor = SISGlobalConstants.calmBlue
        contactUsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        contactUsButton.setTitleColor(.white, for: .normal)
        
        // segmented control config
        let sc = UISegmentedControl(items: ["Images", "Detail"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(segmentedControlValueDidChange(sender:)), for: .valueChanged)
        navigationItem.titleView = sc
    }
    
    // MARK: - Segmented Control
    
    func segmentedControlValueDidChange(sender: UISegmentedControl) {
        let option: UIViewAnimationOptions
        switch sender.selectedSegmentIndex {
        case 0:
            option = .transitionFlipFromRight
        case 1:
            option = .transitionFlipFromLeft
        default:
            return
        }
        UIView.transition(
            with: contentContainer,
            duration: 0.5,
            options: [option],
            animations: {
                switch sender.selectedSegmentIndex {
                case 0:
                    self.detailContainer.isHidden = true
                    self.imageContainer.isHidden = false
                case 1:
                    self.detailContainer.isHidden = false
                    self.imageContainer.isHidden = true
                default:
                    return
                }

        },
            completion: nil)
    }
    
    // MARK: - Contact Us
    
    @IBAction func didPressContactUsButton(_ sender: Any) {
        
        let ac = UIAlertController(
            title: "Contact Us",
            message: "Thanks for your interest! Please choose your method of contact:",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        let phoneCallAction = UIAlertAction(
            title: "Call",
            style: .default,
            handler: { action in
                self.callPhoneNumber(SISGlobalConstants.southerImportSpecialistPhoneNumber)
        })
        ac.addAction(phoneCallAction)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
    func callPhoneNumber(_ phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Detail Large Image Delegate
    
    func didSelectImage(indexPath: IndexPath) {
        largeImageChild.updateCollectionView(indexPath: indexPath)
    }
}









