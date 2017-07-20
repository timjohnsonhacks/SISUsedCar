//
//  SISUsedCarDetailVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/19/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailVC: UIViewController {
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var yearMakeModel: UILabel!
    @IBOutlet weak var collectionAspectRatio: NSLayoutConstraint!
    
    let imageService = SISUsedCarImageService()
    let cellReuseId = "SISUsedCarDetailCVCell"
    var usedCar: SISUsedCar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure vc layout
        NSLayoutConstraint.deactivate([collectionAspectRatio])
        let ar = SISGlobalConstants.defaultAspectRatio
        let arConstraint = NSLayoutConstraint(item: imageCollection, attribute: .width, relatedBy: .equal, toItem: imageCollection, attribute: .height, multiplier: ar, constant: 0.0)
        NSLayoutConstraint.activate([arConstraint])
        collectionAspectRatio = arConstraint
        
        // configure vc text
        yearMakeModel.text = "\(usedCar.year) \(usedCar.make) \(usedCar.model)"
        
        // configure collection view
        imageCollection.dataSource = self
        imageCollection.delegate = self
        imageCollection.backgroundColor = UIColor.black
        
        // get all images
        var userInfo = [String:Any]()
        imageService.GET_allImages(forUsedCar: usedCar, userInfo: &userInfo, completion: { (success, userInfo) in
            guard let row = userInfo["order"] as? Int else {
                return
            }
            let ip = IndexPath(row: row, section: 0)
            DispatchQueue.main.async {
                self.imageCollection.reloadItems(at: [ip])
            }
        })
    }
    
}

extension SISUsedCarDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usedCar.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! SISUsedCarDetailCVCell
        cell.imageView.image = usedCar.images[indexPath.row].image
        return cell
    }
}

extension SISUsedCarDetailVC: UICollectionViewDelegate {
    
}

extension SISUsedCarDetailVC: UICollectionViewDelegateFlowLayout {
    
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
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
