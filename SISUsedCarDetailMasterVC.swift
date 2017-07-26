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
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var yearMakeModelLabel: UILabel!
    @IBOutlet weak var isSoldLabel: CustomIsSoldLabel!
    @IBOutlet weak var contactUsButton: UIButton!
    weak var gradient: SISGradientBackgroundView!
    weak var imageContainer: SISDetailImageLayoutView!
    weak var detailContainer: UIScrollView!
    weak var detailView: SISDetailTextView!
    
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
        
        // image child vc's
        let largeImageVC = SISUsedCarDetailLargeImageVC(usedCar: usedCar, delegate: self)
        let smallImagesVC = SISUsedCarDetailSmallImagesVC(usedCar: usedCar, delegate: self)
        addChildViewController(largeImageVC)
        addChildViewController(smallImagesVC)
        
        let dynamicContainer = SISDetailImageLayoutView(
            frame: .zero,
            largeImageContainer: largeImageVC.view,
            smallImageContainer: smallImagesVC.view,
            aspectRatio: SISGlobalConstants.defaultAspectRatio,
            smallHeight: 60.0)
        contentContainer.addBoundsFillingSubview(dynamicContainer)
        imageContainer = dynamicContainer
        
        largeImageVC.didMove(toParentViewController: self)
        smallImagesVC.didMove(toParentViewController: self)
        largeImageChild = largeImageVC
        smallImagesChild = smallImagesVC
        
        // detail text
        let dtc = UINib(nibName: "SISDetailTextView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! SISDetailTextView
        dtc.configure(usedCar: usedCar)
        let sv = UIScrollView(frame: .zero)
        sv.contentSize = .zero
        sv.addSubview(dtc)
        contentContainer.addBoundsFillingSubview(sv)
        contentContainer.bringSubview(toFront: sv)
        detailContainer = sv
        detailView = dtc
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
    
    override func viewDidAppear(_ animated: Bool) {
        /* TEMPORARY FIX */
        let rect = CGRect(
            x: 0.0,
            y: 0.0,
            width: detailContainer.bounds.width,
            height: 1000)
        detailView.frame = rect
        detailContainer.contentSize = rect.size
    }
    
    func segmentedControlValueDidChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            detailContainer.isHidden = true
            imageContainer.isHidden = false
        case 1:
            detailContainer.isHidden = false
            imageContainer.isHidden = true
        default:
            break
        }
    }
    
    // MARK: - Detail Large Image Delegate
    func largeImageCollectionViewOffsetDidUpdate(percentageTranslation: CGFloat) {
        smallImagesChild.updateCollectionViewOffset(percentageTranslation: percentageTranslation)
    }
    
    func userDidTapSmallImageCollectionView(indexPath: IndexPath) {
        largeImageChild.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}









