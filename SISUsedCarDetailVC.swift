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
    
    let imageService = SISUsedCarImageService()
    let cellReuseId = "SISUsedCarDetailCVCell"
    var usedCar: SISUsedCar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure vc text
        yearMakeModel.text = "\(usedCar.year) \(usedCar.make) \(usedCar.model)"
        
        // configure collection view
        imageCollection.dataSource = self
        imageCollection.delegate = self
        
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
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
}

extension SISUsedCarDetailVC: UICollectionViewDelegate {
    
}
