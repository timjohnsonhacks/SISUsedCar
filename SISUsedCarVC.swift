//
//  SISUsedCarVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarVC: UIViewController {
    
    typealias FilteredCar = (car: SISUsedCar, attributedString: NSMutableAttributedString, score: Int)
    
    // associated views and controllers
    @IBOutlet weak var tableView: UITableView!
    weak var searchPageChild: SISSearchPageVC?
    var searchController: UISearchController!

    // general constants
    let cellID = "SISUsedCarTVCell"
    let searchPageButtonSize = CGSize(width: 44.0, height: 44.0)
    let highlightedAttributes: [String : Any] = [NSForegroundColorAttributeName : UIColor.yellow,
                                                 NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
    
    // networking
    let dataService = SISUsedCarDataService()
    let imageService = SISUsedCarImageService()
    
    // general, unfiltered search
    var allContent = [SISUsedCar]()
    var allContentActivePage: Int = 0
    let allContentItemsPerPage: Int = 10
    
    // filtered search
    var filteredContent = [FilteredCar]()
    var filteredContentActivePage: Int = 0
    let filteredContentItemsPerPage: Int = 10
    
    // search bar restoration
    var searchBarRestorationText: String?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // vc config
        title = "Used Auto"
        
        // table view configuration
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "SISUsedCarTVCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellID)
        
        // search controller config
        let sc = UISearchController(searchResultsController: nil)
        searchController = sc
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.dimsBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = true
        tableView.tableHeaderView = sc.searchBar
        
        // initial networking
        dataService.GET_all(completion: { (cars, _) in
            if let cars = cars {
                self.allContent = cars
                DispatchQueue.main.async {
                    //                    self.setupSearchPageStackTableFooter()
                    self.tableView.reloadData()
                    
                    // search page child config
                    let childVC = SISSearchPageVC(
                        totalItemCount: self.allContent.count,
                        itemsPerPage: self.allContentItemsPerPage,
                        buttonSize: self.searchPageButtonSize,
                        delegate: self)
                    self.addChildViewController(childVC)
                    let container = UIView(frame: CGRect(
                        origin: .zero,
                        size: CGSize(width: self.tableView.bounds.size.width, height: 70)))
                    container.addBoundsFillingSubview(childVC.view)
                    self.tableView.tableFooterView = container
                    childVC.didMove(toParentViewController: self)
                    self.searchPageChild = childVC
                    childVC.giveButtonSelectedAppearance(pageNumber: self.allContentActivePage)
                }
            }
        })
    }
        
    override func viewDidAppear(_ animated: Bool) {
        // search bar restoration
        if let text = searchBarRestorationText {
            searchController.searchBar.text = text
        }
        // configure search bar
        configureSearchPage(forFiltered: false)
    }
    
    // MARK: - Networking
    
    func getMainImageForCar(_ car: SISUsedCar) {
        let userInfo: [String:Any] = [:]
        imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { _ in })
    }
    
    // MARK: - Table View Helpers
    
    func numberOfRows(forPageIndex pageIndex: Int, itemsPerPage: Int, totalItemCount totalCount: Int) -> Int {
        let itemCount: Int
        if (pageIndex + 1) * itemsPerPage <= totalCount {
            itemCount = itemsPerPage
        } else {
            itemCount = totalCount - pageIndex * itemsPerPage
        }
        print("total items: \(totalCount); items per page: \(itemsPerPage)")
        print("page \(pageIndex); item count: \(itemCount)")
        return itemCount
    }
    
    func mappedIndex(forPageIndex pageIndex: Int, itemsPerPage: Int, indexPath: IndexPath) -> Int {
        return pageIndex * itemsPerPage + indexPath.row
    }
    
    // MARK: - Search Page Convenience
    func configureSearchPage(forFiltered filtered: Bool) {
        switch filtered {
        case true:
            searchPageChild?.configure(
                totalItemCount: filteredContent.count,
                itemsPerPage: filteredContentItemsPerPage)
            searchPageChild?.view.isHidden = filteredContent.count == 0 ? true : false
            
        case false:
            searchPageChild?.configure(
                totalItemCount: allContent.count,
                itemsPerPage: allContentItemsPerPage)
            searchPageChild?.view.isHidden = false
        }
        searchPageChild?.giveButtonSelectedAppearance(pageNumber: 0)
        allContentActivePage = 0
        filteredContentActivePage = 0
    }
}














