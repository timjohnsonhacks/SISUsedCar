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
    }
    
    // MARK: - Detail Large Image Delegate
    func largeImageCollectionViewOffsetDidUpdate(percentageTranslation: CGFloat) {
        smallImagesChild.updateCollectionViewOffset(percentageTranslation: percentageTranslation)
    }
    
    func userDidTapSmallImageCollectionView(indexPath: IndexPath) {
        largeImageChild.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}









