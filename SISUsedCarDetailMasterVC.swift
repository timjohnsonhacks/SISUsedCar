//
//  SISUsedCarDetailImagesMasterVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

protocol DetailImagesMasterProtocol {
    func largeImageCollectionViewOffsetDidUpdate(percentageTranslation: CGFloat)
    func userDidTapSmallImageCollectionView(indexPath: IndexPath)
}

protocol DetailSmallImageProtocol {
    func updateCollectionViewOffset(percentageTranslation: CGFloat)
}

class SISUsedCarDetailMasterVC: UIViewController, DetailImagesMasterProtocol {
    
    @IBOutlet weak var largeImageContainer: UIView!
    @IBOutlet weak var smallImagesContainer: UIView!
    @IBOutlet weak var yearMakeModelLabel: UILabel!
    @IBOutlet weak var isSoldLabel: CustomIsSoldLabel!
    @IBOutlet weak var contactUsButton: UIButton!
    weak var gradient: SISGradientBackgroundView!
    
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
    @IBAction func didPressContactUsButton(_ sender: Any) {
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
        
        // large image child vc
        let largeImageVC = SISUsedCarDetailLargeImageVC(usedCar: usedCar, delegate: self)
        addChildViewController(largeImageVC)
        largeImageContainer.addBoundsFillingSubview(largeImageVC.view)
        largeImageVC.didMove(toParentViewController: self)
        largeImageChild = largeImageVC
        
        // small image child vc
        let smallImagesVC = SISUsedCarDetailSmallImagesVC(usedCar: usedCar, delegate: self)
        addChildViewController(smallImagesVC)
        smallImagesContainer.addBoundsFillingSubview(smallImagesVC.view)
        smallImagesVC.didMove(toParentViewController: self)
        smallImagesChild = smallImagesVC
        
        // basic label config
        yearMakeModelLabel.text = usedCar.yearMakeModel
        yearMakeModelLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        yearMakeModelLabel.textAlignment = .center
        
        isSoldLabel.isSold = usedCar.isSold
        
        contactUsButton.backgroundColor = SISGlobalConstants.calmBlue
        contactUsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        contactUsButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Detail Large Image Delegate
    func largeImageCollectionViewOffsetDidUpdate(percentageTranslation: CGFloat) {
        smallImagesChild.updateCollectionViewOffset(percentageTranslation: percentageTranslation)
    }
    
    func userDidTapSmallImageCollectionView(indexPath: IndexPath) {
        largeImageChild.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}









