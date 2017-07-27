//
//  SISUsedCarVC+SearchPage.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

// MARK: - Search Page Button Delegate

extension SISUsedCarVC: SISSearchPageButtonDelegate {
    
    func didTapButtonWith(titleNumber: Int) {
        if titleNumber == searchPageChildVc.lastSelectedTitleNumber! || searchController.isActive == true { return }

        shouldFetchImage = false
        tableView.beginUpdates()
        activeContentIndex = titleNumber
        let insertPaths = allPathsForActiveContentIndex(titleNumber)
        let deletePaths = allPathsForActiveContentIndex(searchPageChildVc.lastSelectedTitleNumber!)
        tableView.insertRows(
            at: insertPaths,
            with: titleNumber > searchPageChildVc.lastSelectedTitleNumber! ? .right : .left)
        tableView.deleteRows(at: deletePaths, with: .fade)
        tableView.endUpdates()
        
        searchPageChildVc.giveButtonSelectedAppearance(titleNumber: titleNumber)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            let scrollPath = IndexPath(row: 0, section: 0)
//            self.tableView.scrollToRow(at: scrollPath, at: .top, animated: true)
        })
    }
    
    func allPathsForActiveContentIndex(_ aci: Int) -> [IndexPath] {
        var paths = [IndexPath]()
        for i in 0..<numberOfRowsForActiveContentIndex(aci) {
            paths.append(
                IndexPath(
                    row: i,
                    section: 0)
            )
        }
        return paths
    }
}

extension SISUsedCarVC: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        searchPageChildVc.view.isHidden = false
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchPageChildVc.view.isHidden = true
    }
}

extension SISUsedCarVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search text: \(searchText)")
        searchBarRestorationText = searchText
        print("search bar restoration search text: \(searchBarRestorationText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarRestorationText = nil
    }
}






