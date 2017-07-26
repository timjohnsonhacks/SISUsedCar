//
//  SISUsedCarDetailLargeImageVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailLargeImageVC: UIViewController {
    
    
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
        var userInfo: [String:Any] = [:]
        imageService.GET_allImages(forUsedCar: usedCar, userInfo: &userInfo, completion: { (success, userInfo) in
            guard let row = userInfo["order"] as? Int else {
                return
            }
            let ip = IndexPath(row: row, section: 0)
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [ip])
            }
        })
        
        // collection view config
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SISUsedCarDetailCVCell.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
    }
}

// MARK: - Collection View Data Source
extension SISUsedCarDetailLargeImageVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usedCar.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! SISUsedCarDetailCVCell
        cell.imageView.image = usedCar.images[indexPath.row].image
        cell.configureBorder(true)
        return cell
    }
}

// MARK: - Collection View Delegate
extension SISUsedCarDetailLargeImageVC: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let insets = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, insetForSectionAt: 0)
        let xOffset = collectionView.contentOffset.x - insets.left
        let xRange = collectionView.contentSize.width - insets.left - insets.right
        delegate.largeImageCollectionViewOffsetDidUpdate(percentageTranslation: xOffset / xRange)
    }
}

// MARK: - Collection View Delegate Flow Layout
extension SISUsedCarDetailLargeImageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let containerSize = collectionView.bounds.size
        let containerAspectRatio: CGFloat = containerSize.width / containerSize.height
        
        let imageAspectRatio: CGFloat
        if let image = usedCar.images[indexPath.row].image {
            imageAspectRatio = image.size.width / image.size.height
        } else {
            imageAspectRatio = SISGlobalConstants.defaultAspectRatio
        }
        
        let cellSize: CGSize
        let scaleFactor: CGFloat = 0.95
        if imageAspectRatio > containerAspectRatio {
            
            let width = containerSize.width * scaleFactor
            cellSize = CGSize(width: width, height: width / imageAspectRatio)
            
        } else if imageAspectRatio < containerAspectRatio {
            
            let height = containerSize.height * scaleFactor
            cellSize = CGSize(width: height * imageAspectRatio, height: height)
            
        } else {
            
            cellSize = containerSize
            
        }
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40.0
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
