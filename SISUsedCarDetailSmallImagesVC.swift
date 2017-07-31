//
//  SISUsedCarDetailSmallImagesVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailSmallImagesVC: UIViewController, DetailSmallImageProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let usedCar: SISUsedCar
    let imageService = SISUsedCarImageService()
    let cellReuseId = "SISUsedCarDetailCVCell"
    let delegate: DetailImagesMasterProtocol
    
    // MARK: - Instantiation
    
    init(usedCar: SISUsedCar, delegate: DetailImagesMasterProtocol) {
        self.usedCar = usedCar
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all images
//        let userInfo: [String:Any] = [:]
//        imageService.GET_allImages(forUsedCar: usedCar, userInfo: userInfo, completion: { info in
//            guard let row = info[SISUsedCarImageService.InfoKeys.imageIndex.rawValue] as? Int else {
//                return
//            }
//            let ip = IndexPath(row: row, section: 0)
//            DispatchQueue.main.async {
//                self.collectionView.reloadItems(at: [ip])
//            }
//        })
        
        // collection view config
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SISUsedCarDetailCVCell.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.layer.borderColor = UIColor.darkGray.cgColor
        collectionView.layer.borderWidth = 1.0
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
    }
    
    // MARK: - Detail Image Collection View Protocol
    func updateCollectionViewOffset(percentageTranslation: CGFloat) {
        let xOffset = offset(fromPercentageTranslation: percentageTranslation)
        collectionView.contentOffset = CGPoint(x: xOffset, y: 0)
    }
    
    func offset(fromPercentageTranslation percentage: CGFloat) -> CGFloat {
        return xRange() * percentage
    }
    
    func percentageTranslation(fromOffset x: CGFloat) -> CGFloat {
        return x / xRange()
    }
    
    func xRange() -> CGFloat {
        let insets = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, insetForSectionAt: 0)
        return collectionView.contentSize.width - insets.left - insets.right
    }
}

extension SISUsedCarDetailSmallImagesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = usedCar.images.count
        return count > 0 ? count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = usedCar.images.count
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! SISUsedCarDetailCVCell
        if count > 0 {
            cell.imageView.image = usedCar.images[indexPath.row].image
            cell.configureBorder(false)
            
        } else {
            cell.imageView.backgroundColor = UIColor.red
        }

        return cell
    }
}

extension SISUsedCarDetailSmallImagesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.userDidTapSmallImageCollectionView(indexPath: indexPath)
    }
}

extension SISUsedCarDetailSmallImagesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let containerSize = collectionView.bounds.size
        let imageAspectRatio: CGFloat
        if usedCar.images.count - 1 >= indexPath.row,
            let image = usedCar.images[indexPath.row].image {
            imageAspectRatio = image.size.width / image.size.height
        } else {
            imageAspectRatio = SISGlobalConstants.defaultAspectRatio
        }
        let scaleFactor: CGFloat = 1.0
        let scaledHeight = containerSize.height * scaleFactor
        let cellSize = CGSize(
            width: scaledHeight * imageAspectRatio,
            height: scaledHeight)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftCellSize = self.collectionView(collectionView,
                                               layout: collectionView.collectionViewLayout,
                                               sizeForItemAt: IndexPath(row: 0, section: 0))
        let leftInset = (collectionView.bounds.size.width - leftCellSize.width) / 2.0
        
        let rightLimit = self.collectionView(collectionView, numberOfItemsInSection: 0) - 1
        let rightCellSize = self.collectionView(collectionView,
                                                layout: collectionView.collectionViewLayout,
                                                sizeForItemAt: IndexPath(row: rightLimit, section: 0))
        let rightInset = (collectionView.bounds.size.width - rightCellSize.width) / 2.0
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
