//
//  SISDetailImagesVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/20/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISDetailImagesVC: UIViewController {

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var collectionAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    let imageService = SISUsedCarImageService()
    let cellReuseId = "SISUsedCarDetailCVCell"
    var usedCar: SISUsedCar
    var activeIndexPath: IndexPath!
    
    init(usedCar: SISUsedCar) {
        self.usedCar = usedCar
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
                self.imageCollection.reloadItems(at: [ip])
            }
        })
        
        // configure collection view layout
        NSLayoutConstraint.deactivate([collectionAspectRatio])
        let ar = SISGlobalConstants.defaultAspectRatio
        let arConstraint = NSLayoutConstraint(item: imageCollection, attribute: .width, relatedBy: .equal, toItem: imageCollection, attribute: .height, multiplier: ar, constant: 0.0)
        NSLayoutConstraint.activate([arConstraint])
        collectionAspectRatio = arConstraint
        
        // configure collection view
        imageCollection.dataSource = self
        imageCollection.delegate = self
        imageCollection.register(SISUsedCarDetailCVCell.self, forCellWithReuseIdentifier: cellReuseId)
        imageCollection.backgroundColor = UIColor.clear
        
        /* probably need to make more elegant */
        activeIndexPath = IndexPath(row: 0, section: 0)
    }
    
    // MARK: - Arrow Buttons
    
    @IBAction func didPressLeftArrowButton(sender: UIButton) {
        incrementPresentedImage(direction: .Left)
    }
    
    @IBAction func didPressRightArrowButton(sender: UIButton) {
        incrementPresentedImage(direction: .Right)
    }
    
    enum ArrowDirection { case Left, Right }
    
    func incrementPresentedImage(direction: ArrowDirection) {
        let currentRow = activeIndexPath.row
        let next: IndexPath
        switch direction {
        case .Left:
            next = currentRow == 0 ? activeIndexPath : IndexPath(row: currentRow - 1, section: 0)
        case .Right:
            let maxRow = imageCollection.numberOfItems(inSection: 0) - 1
            next = currentRow == maxRow ? activeIndexPath : IndexPath(row: currentRow + 1, section: 0)
        }
        activeIndexPath = next
        imageCollection.scrollToItem(at: next, at: .centeredHorizontally, animated: true)
    }
    
}

extension SISDetailImagesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usedCar.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! SISUsedCarDetailCVCell
        cell.imageView.layer.borderColor = UIColor.black.cgColor
        cell.imageView.layer.borderWidth = 2.0
        cell.imageView.image = usedCar.images[indexPath.row].image
        return cell
    }
}

extension SISDetailImagesVC: UICollectionViewDelegate {
    
}

extension SISDetailImagesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let containerSize = imageCollection.bounds.size
        let containerAspectRatio: CGFloat = containerSize.width / containerSize.height
        
        let imageAspectRatio: CGFloat
        if let image = usedCar.images[indexPath.row].image {
            imageAspectRatio = image.size.width / image.size.height
        } else {
            imageAspectRatio = SISGlobalConstants.defaultAspectRatio
        }
        
        let cellSize: CGSize
        if imageAspectRatio > containerAspectRatio {
            
            cellSize = CGSize(width: containerSize.width, height: containerSize.width / imageAspectRatio)
            
        } else if imageAspectRatio < containerAspectRatio {
            
            cellSize = CGSize(width: containerSize.height * imageAspectRatio, height: containerSize.height)
            
        } else {
            
            cellSize = containerSize
            
        }
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
