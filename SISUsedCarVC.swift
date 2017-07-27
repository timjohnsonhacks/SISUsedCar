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
    weak var searchPageChildVc: SISSearchPageVC!
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
    
    var shouldFetchImage: Bool = true
    var selectedCar: SISUsedCar?
    var searchBarRestorationText: String?
    
//    var activeContentStartIndex: Int {
//        return activeContentIndex * itemsPerSection
//    }
//    var activeContentEndIndex: Int {
//        return (activeContentIndex + 1) * itemsPerSection - 1
//    }
//    var activeContent: [SISUsedCar] {
//        return Array(allContent[activeContentStartIndex...activeContentEndIndex])
//    }
    
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
                }
            }
        })
    }
    
//    func setupSearchPageStackTableFooter() {
//        // add search page vc's view to footer
//        let childVC = SISSearchPageVC(
//            totalItemCount: allContent.count,
//            itemsPerSection: itemsPerSection,
//            buttonSize: searchPageButtonSize,
//            delegate: self)
//        addChildViewController(childVC)
//        let container = UIView(frame: CGRect(
//            origin: .zero,
//            size: CGSize(width: tableView.bounds.size.width, height: 70)))
//        container.addBoundsFillingSubview(childVC.view)
//        tableView.tableFooterView = container
//        childVC.didMove(toParentViewController: self)
//        searchPageChildVc = childVC
//        childVC.giveButtonSelectedAppearance(titleNumber: activeContentIndex)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear search bar restoration search text: \(searchBarRestorationText)")
        // initial car download
//        if allContent.count == 0 {
//            getAll()
//        }
        
        // search bar restoration
        if let text = searchBarRestorationText {
            searchController.searchBar.text = text
        }
    }
    
    // MARK: - Networking
    
    func getAll() {
        dataService.GET_all(completion: { (cars, _) in
            if let cars = cars {
                self.allContent = cars

                DispatchQueue.main.async {
//                    self.setupSearchPageStackTableFooter()
                    self.tableView.reloadData()
                }
            }
        })
    }

    
    func getMainImageForCar(_ car: SISUsedCar) {
        let userInfo: [String:Any] = [:]
        imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { info in
        })
    }
    
//    func fetchAllMainImages() {
//        for car in content {
////            guard let ip = mapping[car.id] else {
////                continue
////            }
//            let ip = IndexPath(row: 0, section: 0)
//            let userInfo: [String:Any] = ["indexPath" : ip]
//            
//            imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { (success, userInfo) in
//                guard let ip = userInfo["indexPath"] as? IndexPath else {
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadRows(at: [ip], with: .none)
//                }
//                if success == false {
//                    print("image download not successful for car: \(car.shortDescription)")
//                    if let mainImageUrl = car.images.first?.fullPath {
//                        print("main image path: \(mainImageUrl)")
//                    } else {
//                        print("no main image url")
//                    }
//                }
//            })
//        }
//    }
    
    // MARK: - General
    
//    func activelyDisplayedCars() -> [(SISUsedCar, IndexPath)] {
//        /* get all visible cells from the table view.  Return a tuple containing the used car and associated index path. This method is to be used primarily to facillitate networking completion calls - if the cell is visible, then update its image. Otherwise, table view data source methods will automatically display the downloaded image when dequeuing cells */
//        for cell in tableView.visibleCells {
//            guard let cell = cell as? SISUsedCarTVCell else {
//                continue
//            }
//            
//        }
//    }
    // MARK: - Table View Helpers
    
    func numberOfRows(forPageIndex pageIndex: Int, itemsPerPage: Int, totalItemCount totalCount: Int) -> Int {
        if pageIndex * (itemsPerPage + 1) < totalCount {
            return itemsPerPage
        } else {
            return totalCount - pageIndex * itemsPerPage
        }
    }
    
    func mappedIndex(forPageIndex pageIndex: Int, itemsPerPage: Int, indexPath: IndexPath) -> Int {
        return pageIndex * itemsPerPage + indexPath.row
    }
}














