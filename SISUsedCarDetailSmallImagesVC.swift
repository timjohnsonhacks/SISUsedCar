//
//  SISUsedCarDetailSmallImagesVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarDetailSmallImagesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var touchView: UIView! /* controls swiping events for the collection view */
    
    let usedCar: SISUsedCar
    let imageService = SISUsedCarImageService()
    let cellReuseId = "SISUsedCarDetailCVCell"
    let delegate: DetailImagesMaster
    
    var activeIndex: Int = 0
    
    // MARK: - Instantiation
    
    init(usedCar: SISUsedCar, delegate: DetailImagesMaster) {
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
        
        // collection view config
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SISUsedCarDetailCVCell.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        
        // touch view
        let tv = UIView(frame: .zero)
        view.addBoundsFillingSubview(tv)
        view.bringSubview(toFront: tv)
        touchView = tv
        
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(didPan(pan:)))
        touchView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(tap:)))
        touchView.addGestureRecognizer(tap)
    }
    
    // MARK: - Gesture Recognizers
    
    @objc private func didPan(pan: UIPanGestureRecognizer) {
        /* move the collection view laterally within defined bounds smaller than the default content area. Blank space will never be shown to the right or left of images in the collection view */
        let translation = pan.translation(in: view)
        let xDelta = translation.x * -4.0
        let finalX = collectionView.contentOffset.x + xDelta
        let left = leftRoom()
        let right = rightRoom()
        
        if ( xDelta > 0.0 && xDelta < right ) ||
            (xDelta < 0.0 && xDelta * -1.0 < left ) {
            collectionView.contentOffset = CGPoint(
                x: finalX,
                y: collectionView.contentOffset.y)
            
        } else if xDelta > 0.0 && xDelta > right {
            collectionView.contentOffset = CGPoint(
                x: collectionView.contentOffset.x + right,
                y: collectionView.contentOffset.y)
            
        } else if xDelta < 0 && xDelta * -1.0 > left {
            collectionView.contentOffset = CGPoint(
                x: collectionView.contentOffset.x - left,
                y: collectionView.contentOffset.y)
        }
        
        pan.setTranslation(.zero, in: view)
        updateDependentOffset()
    }
    
    private func leftRoom() -> CGFloat {
        return collectionView.contentOffset.x
    }
    
    private func rightRoom() -> CGFloat {
        return collectionView.contentSize.width - collectionView.bounds.width - collectionView.contentOffset.x
    }
    
    private func updateDependentOffset() {
        let maxRestrictedOffset = collectionView.contentSize.width - collectionView.bounds.width
        let offsetPercent = collectionView.contentOffset.x / maxRestrictedOffset
        let count = collectionView.numberOfItems(inSection: 0)
        var index: Int = Int(floor( CGFloat(count) * offsetPercent ))
        if index == count {
            index -= 1
        }
        let ip = IndexPath(row: index, section: 0)
        delegate.didSelectImage(indexPath: ip)
        selectCell(index: index)
    }
    
    private func selectCell(index: Int) {
        let previousPath = IndexPath(row: self.activeIndex, section: 0)
        if let previousCell = collectionView.cellForItem(at: previousPath) as? SISUsedCarDetailCVCell {
            previousCell.configureAppearance(.Default)
        }
        let currentPath = IndexPath(row: index, section: 0)
        if let currentCell = collectionView.cellForItem(at: currentPath) as? SISUsedCarDetailCVCell {
            currentCell.configureAppearance(.Selected)
        }
        activeIndex = index
    }
    
    @objc private func didTap(tap: UITapGestureRecognizer) {
        /* use hit testing and recursion to find the tapped cell, if there is one. Report the tapped cell to the delegate */
        let cvPoint = tap.location(in: collectionView)
        let hitTestView = collectionView.hitTest(cvPoint, with: nil)
        if var htv = hitTestView {
            while true {
                if let hitTestCell = htv as? SISUsedCarDetailCVCell {
                    if let ip = collectionView.indexPath(for: hitTestCell) {
                        // configure selected appearance and update state
                        selectCell(index: ip.row)
                        
                        // call delegate
                        delegate.didSelectImage(indexPath: ip)
                    }
                    return
                }
                
                if htv === collectionView {
                    return
                    
                } else {
                    if let sv = htv.superview {
                        htv = sv
                    } else {
                        return
                    }
                }
            }
        }
    }
}

// MARK: - Collection View Data Source

extension SISUsedCarDetailSmallImagesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = usedCar.images.count
        return count > 0 ? count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = usedCar.images.count
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! SISUsedCarDetailCVCell
        let appearance = indexPath.row == activeIndex ? SISUsedCarDetailCVCell.Appearance.Selected : SISUsedCarDetailCVCell.Appearance.Default
        cell.configureAppearance(appearance)
        cell.configureNotificationsForCar(
            usedCar: usedCar,
            imageIndex: indexPath.row)
        if count > 0 {
            guard usedCar.images.count - 1 >= indexPath.row else {
                return cell
            }
            let container = usedCar.images[indexPath.row]
            if let image = usedCar.images[indexPath.row].image {
                cell.configureImage(image)
                
            } else if container.downloadAttemptFailed == false {
                cell.showActivityIndicator()
                imageService.GET_image(
                    forUsedCar: usedCar,
                    imageIndex: indexPath.row,
                    userInfo: [:],
                    completion: { _ in })
                
            } else {
                cell.showNoImageAvailable()
                
            }
            
        } else {
            cell.showNoImageAvailable()
        }
        return cell
    }
}

// MARK: - Collection View Delegate Flow Layout

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
        return 40.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
