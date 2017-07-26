//
//  SISUsedCarVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/18/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISUsedCarVC: UIViewController {

    let cellID = "SISUsedCarTVCell"
    let dataService = SISUsedCarDataService()
    let imageService = SISUsedCarImageService()
    
    typealias FilteredCar = (car: SISUsedCar, attributedString: NSMutableAttributedString, score: Int)
    var filteredContent = [FilteredCar]()
    var shouldFetchImage: Bool = true
    var content = [SISUsedCar]() {
        didSet {
            /* mapping depends on content, so configure mapping when content is set */
            var newMapping: [Int:IndexPath] = [:]
            var row: Int = 0
            for cont in content {
                let key: Int = cont.id
                let value = IndexPath(row: row, section: 0)
                newMapping[key] = value
                row += 1
            }
            mapping = newMapping
        }
    }
    var mapping: [Int : IndexPath] = [:] /*  usedCar.id : indexPath ; for cell updating */
    let itemsPerSection: Int = 10
    var activeContentIndex: Int = 0
    let searchPageButtonSize = CGSize(width: 44.0, height: 44.0)
    var selectedCar: SISUsedCar?
    weak var searchPageChildVc: SISSearchPageVC!
    var searchController: UISearchController!
    let highlightedAttributes: [String : Any] = [NSForegroundColorAttributeName : UIColor.yellow,
                                                 NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
    
    var activeContentStartIndex: Int {
        return activeContentIndex * itemsPerSection
    }
    var activeContentEndIndex: Int {
        return (activeContentIndex + 1) * itemsPerSection - 1
    }
    var activeContent: [SISUsedCar] {
        return Array(content[activeContentStartIndex...activeContentEndIndex])
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // vc config
        title = "Used Cars"
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // initial car download
        if content.count == 0 {
            getAll()
        }
    }
    
    func getAll() {
        dataService.GET_all(completion: { (cars, _) in
            
            if let cars = cars {
                self.content = cars

                DispatchQueue.main.async {
                    self.setupSearchPageStackTableFooter()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func setupSearchPageStackTableFooter() {
        // add search page vc's view to footer
        let childVC = SISSearchPageVC(
            totalItemCount: content.count,
            itemsPerSection: itemsPerSection,
            buttonSize: searchPageButtonSize,
            delegate: self)
        addChildViewController(childVC)
        let container = UIView()
        container.addBoundsFillingSubview(childVC.view)
        tableView.tableFooterView = container
        configureTableFooterViewFrame(isShowing: true)
        childVC.didMove(toParentViewController: self)
        searchPageChildVc = childVC
        childVC.giveButtonSelectedAppearance(titleNumber: activeContentIndex)
    }
    
    func getMainImageForCar(_ car: SISUsedCar, indexPath: IndexPath, requestContentIndex: Int) {
        let userInfo: [String:Any] = ["indexPath" : indexPath,
                                      "requestContentIndex" : requestContentIndex]
        
        imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { (success, userInfo) in
            guard let ip = userInfo["indexPath"] as? IndexPath,
                let requestContentIndex = userInfo["requestContentIndex"] as? Int else {
                return
            }
            
            if self.activeContentIndex == requestContentIndex {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [ip], with: .none)
                }
            }
 
            if success == false {
                print("image download not successful for car: \(car.shortDescription)")
                if let mainImageUrl = car.images.first?.fullPath {
                    print("main image path: \(mainImageUrl)")
                } else {
                    print("no main image url")
                }
            }
        })
    }
    
    func fetchAllMainImages() {
        for car in content {
            guard let ip = mapping[car.id] else {
                continue
            }
            let userInfo: [String:Any] = ["indexPath" : ip]
            
            imageService.GET_mainImage(forUsedCar: car, userInfo: userInfo, completion: { (success, userInfo) in
                guard let ip = userInfo["indexPath"] as? IndexPath else {
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [ip], with: .none)
                }
                if success == false {
                    print("image download not successful for car: \(car.shortDescription)")
                    if let mainImageUrl = car.images.first?.fullPath {
                        print("main image path: \(mainImageUrl)")
                    } else {
                        print("no main image url")
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            searchController.isActive = false
            let detailVC = segue.destination as! SISUsedCarDetailVC
            detailVC.usedCar = selectedCar!
        }
    }
    
    func numberOfRowsForActiveContentIndex(_ aci: Int) -> Int {
        switch searchController.isActive {
        case false:
            if aci * (itemsPerSection + 1) < content.count {
                return itemsPerSection
            } else {
                return content.count - aci * itemsPerSection
            }
            
        case true:
            return filteredContent.count
        }
    }
    
    func configureTableFooterViewFrame(isShowing: Bool) {
        switch isShowing {
        case true:
             let rect = CGRect(
                origin: .zero,
                size: CGSize(width: tableView.bounds.size.width, height: 70))
//             print("rect for table footer view: \(rect)")
             tableView.tableFooterView?.frame = rect
        case false:
            tableView.tableFooterView?.frame = .zero
        }
    }
}














