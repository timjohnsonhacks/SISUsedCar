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
        if pageNumber == searchPageChild?.lastSelectedPageNumber {
            return
        }
        // table view updates
        tableView.beginUpdates()
        
        tableView.contentOffset = .zero
        
        /*
        * This is a lot more complicated than it needs to be. Essentially, the table view is always displaying the same
        * number of rows, unless its the last page. So instead of figuring what index paths to insert and delete, you
        * really should just be reloading the rows, and altering the data you want to show. The data you want to show is the
        * cars you have for all the pages, in the range of the current page. So when you change the page, it's best to update
        * the data, then simply call reload. Unless you want that animation - its a little more complicated, but not much.
        */
        
        let insertPaths = indexPaths(forPageIndex: pageNumber)
        let currentPage = searchController.isActive == true ? filteredContentActivePage : allContentActivePage
        let deletePaths = indexPaths(forPageIndex: currentPage)
        tableView.insertRows(
            at: insertPaths,
            with: pageNumber > currentPage ? .right : .left)
        tableView.deleteRows(
            at: deletePaths,
            with: .fade)
        
        switch searchController.isActive {
        case true:
            filteredContentActivePage = pageNumber
            
        case false:
            allContentActivePage = pageNumber
        }
        
        tableView.endUpdates()
        
        // update selected state of search page child
        searchPageChild?.giveButtonSelectedAppearance(pageNumber: pageNumber)
    }
    
    private func indexPaths(forPageIndex page: Int) -> [IndexPath] {
        let itemsPerPage: Int
        let totalItemCount: Int
        switch searchController.isActive {
        case true:
            // filtered search
            itemsPerPage = filteredContentItemsPerPage
            totalItemCount = filteredContent.count
            
        case false:
            // general, unfiltered search
            itemsPerPage = allContentItemsPerPage
            totalItemCount = allContent.count
        }
        let rowCount = numberOfRows(
            forPageIndex: page,
            itemsPerPage: itemsPerPage,
            totalItemCount: totalItemCount)
        var paths = [IndexPath]()
        for i in 0..<rowCount {
            let path = IndexPath(row: i, section: 0)
            paths.append(path)
        }
        return paths
    }
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






