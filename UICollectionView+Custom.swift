//
//  UICollectionView+Custom.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/21/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func indexPathForPrevalentCell() -> IndexPath? {
        let candidateCells = visibleCells
        if candidateCells.count == 0 { return nil }
        
        var prevalentCell: UICollectionViewCell?
        var prevalentArea: CGFloat = 0.0
        let visibleFrame = CGRect(x: contentOffset.x, y: contentOffset.y, width: bounds.width, height: bounds.height)
        
        for cell in candidateCells {
            guard let cellFrame = cell.contentView.superview?.frame else {
                continue
            }
            let intersectRect = visibleFrame.intersection(cellFrame)
            let intersectArea: CGFloat = intersectRect.width * intersectRect.height
            if intersectArea > prevalentArea {
                prevalentArea = intersectArea
                prevalentCell = cell
            }
        }
        if let prevalentCell = prevalentCell {
            return indexPath(for: prevalentCell)
        } else {
            return nil
        }
    }
}
