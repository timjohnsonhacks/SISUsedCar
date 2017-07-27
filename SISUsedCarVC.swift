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
    
    @IBOutlet weak var tableView: UITableView!
    weak var searchPageChildVc: SISSearchPageVC!
    var searchController: UISearchController!

    let cellID = "SISUsedCarTVCell"
    let dataService = SISUsedCarDataService()
    let imageService = SISUsedCarImageService()
    let searchPageButtonSize = CGSize(width: 44.0, height: 44.0)
    let itemsPerSection: Int = 10
    let highlightedAttributes: [String : Any] = [NSForegroundColorAttributeName : UIColor.yellow,
                                                 NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
    
    var content = [SISUsedCar]()
    var filteredContent = [FilteredCar]()
    var activeContentIndex: Int = 0
    
    var shouldFetchImage: Bool = true
    var selectedCar: SISUsedCar?
    var searchBarRestorationText: String?
    
    var activeContentStartIndex: Int {
        return activeContentIndex * itemsPerSection
    }
    var activeContentEndIndex: Int {
        return (activeContentIndex + 1) * itemsPerSection - 1
    }
    var activeContent: [SISUsedCar] {
        return Array(content[activeContentStartIndex...activeContentEndIndex])
    }
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear search bar restoration search text: \(searchBarRestorationText)")
        // initial car download
        if content.count == 0 {
            getAll()
        }
        
        // search bar restoration
        if let text = searchBarRestorationText {
            searchController.searchBar.text = text
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
        let container = UIView(frame: CGRect(
            origin: .zero,
            size: CGSize(width: tableView.bounds.size.width, height: 70)))
        container.addBoundsFillingSubview(childVC.view)
        tableView.tableFooterView = container
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
}














