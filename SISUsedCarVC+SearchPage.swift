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
    
    func didTapButtonWith(pageNumber: Int) {
//        if titleNumber == searchPageChildVc.lastSelectedTitleNumber! || searchController.isActive == true { return }
//
//        shouldFetchImage = false
//        tableView.beginUpdates()
//        activeContentIndex = titleNumber
//        let insertPaths = allPathsForActiveContentIndex(titleNumber)
//        let deletePaths = allPathsForActiveContentIndex(searchPageChildVc.lastSelectedTitleNumber!)
//        tableView.insertRows(
//            at: insertPaths,
//            with: titleNumber > searchPageChildVc.lastSelectedTitleNumber! ? .right : .left)
//        tableView.deleteRows(at: deletePaths, with: .fade)
//        tableView.endUpdates()
//        
//        searchPageChildVc.giveButtonSelectedAppearance(titleNumber: titleNumber)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
////            let scrollPath = IndexPath(row: 0, section: 0)
////            self.tableView.scrollToRow(at: scrollPath, at: .top, animated: true)
//        })
    }
    
//    func allPathsForActiveContentIndex(_ aci: Int) -> [IndexPath] {
//        var paths = [IndexPath]()
//        for i in 0..<numberOfRowsForActiveContentIndex(aci) {
//            paths.append(
//                IndexPath(
//                    row: i,
//                    section: 0)
//            )
//        }
//        return paths
//    }
}

extension SISUsedCarVC: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        // will show general, unfiltered search following dismissal
        configureSearchPage(forFiltered: false)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // will show iltered search following dismissal
        configureSearchPage(forFiltered: true)
    }
}

extension SISUsedCarVC: UISearchBarDelegate {
    // methods used to facillitate restoration of search bar text following detail scene presentation and dismissal
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarRestorationText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarRestorationText = nil
        configureSearchPage(forFiltered: false)
    }
}






