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
    @IBOutlet weak var searchPageContainer: UIView!
    weak var searchPageChild: SISSearchPageVC?
    
    /* Using `!` is bad practice in general. Its best to remove the `!` here and instantiate the searchController in init*/
    var searchController: UISearchController!
    
    // keyboard management
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!

    /* 
    * Personally, I like to put constants in a Constants struct outside of the class, at the top of the file, that is only
    * accessible to the file. Something like
    *
    * private struct Constants {
    *     static let cellID = "SISUsedCarTVCell"
    *     ...
    *     ...
    * }
    * Obviously this is my preference, but I think it cleans up the code a bit and makes it nice
    */
    
    // general constants
    let cellID = "SISUsedCarTVCell"
    let searchPageButtonSize = CGSize(width: 44.0, height: 44.0)
    let highlightedAttributes: [String : Any] = [NSForegroundColorAttributeName : UIColor.yellow,
                                                 NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
    
    /* 
    * I like what you're going for here. Keeping the network services and image services their own individual entity.
    * I think a better practice is actually only having one instance of a network service. This keeps all of the networking
    * being handled by one object, which is better for following the flow of data through one object, as opposed to multiple.
    * This allows for easier debugging, easier thread management, etc. I don't suggest using a singleton, but I do think its
    * worth using a single instance throughout the application that is passed around where you need it. I recommend the same
    * for the image service.
    */
    
    // networking
    let dataService = SISUsedCarDataService()
    let imageService = SISUsedCarImageService()
    
    /* 
    * I think that the naming here could be a bit better. AllContent creates the assumption that there are going to be
    * multiple kinds of content, whereas clearly there are only cars in use. It might be better to change the name from 
    * `allContent` to `cars`. It is easier to understand what you are getting when using the variable later. 
    */
    
    /*
    */
    
    // general, unfiltered search
    var allContent = [SISUsedCar]()
    var allContentActivePage: Int = 0
    let allContentItemsPerPage: Int = 10
    
    /*
    * I don't think you need this concept of the filtered content. This is creating a lot of points in your code where 
    * you have to check if you are in the filtered state or not, and the only thing that seems to actually be different
    * is what is being displayed, not really any other changes. A better solution is to just have one array hold on to
    * the original content, while having a second array holding onto what is being displayed. Something like:
    *
    * var originalCars = [SISUsedCar]()
    * var cars = [SISUsedCar]()
    *
    * With this, you only ever have to interact with the cars array. When you are searching, all you need to do is set
    * the cars array to the original cars, filtered by the search text. When not searching, the cars array will just be
    * the original cars. This will make the code cleaner and easier to follow.
    */
    
    // filtered search
    var filteredContent = [FilteredCar]()
    var filteredContentActivePage: Int = 0
    let filteredContentItemsPerPage: Int = 10
    
    // search bar restoration
    var searchBarRestorationText: String?
    
    // MARK: - View Life Cycle
    
    /*
    * A lot is going on here in `viewDidLoad()`. I recommend stubbing out some bits of logic into their own functions.
    * Moving the notification observer setup into its own method would make sense, as well as the initial fetch from
    * the data service. This cleans up the code a bit and doesn't make `viewDidLoad()` as overwhelming.
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // vc config
        title = "Used Auto"
        
        // table view configuration
        tableView.dataSource = self
        tableView.delegate = self
        
        /* You have this string in a constant above */
        let cellNib = UINib(nibName: "SISUsedCarTVCell", bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: cellID)
        
        /* 
        * `sc` is a bad name here. If I'm a developer working on this later on, and I have to use sc, I have no idea
        * what it is or what its purpose is base on that name.
        * 
        * Also, you can just assign the searchController directly, instead of assigned the object `sc` to it, and then
        * refer solely to it as `searchController`
        */
        
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
        
        /*
        * Make sure you remove the notification observer on `deinit`. If you don't do that then the SISUsedCarVC will
        * hang around in memory becuase the NotificationCenter will be holding on to it
        */
        // keyboard notification config
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: .UIKeyboardWillShow,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: .UIKeyboardWillHide,
            object: nil)

        // initial networking
        dataService.GET_all(completion: { (cars, _) in
            if let cars = cars {
                self.allContent = cars
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    // search page child config
                    let childVC = SISSearchPageVC(
                        totalItemCount: self.allContent.count,
                        itemsPerPage: self.allContentItemsPerPage,
                        buttonSize: self.searchPageButtonSize,
                        delegate: self)
                    self.addChildViewController(childVC)
                    self.searchPageContainer.addBoundsFillingSubview(childVC.view)
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
    /*
    * This code doesn't seem to be used in this file. It's best to keep them in the file where they're being used
    * and mark them as private or fileprivate. That way they aren't exposed. This helps to curate good coding style
    * and forces you to think how you want your code to be accessed throughout the app.
    */
    func getMainImageForCar(_ car: SISUsedCar) {
        imageService.GET_mainImage(
            forUsedCar: car,
            userInfo: [:],
            completion: { _ in })
    }
    
    /*
    * Ditto from the above comment.
    */
    // MARK: - Table View Helpers
    
    func numberOfRows(forPageIndex pageIndex: Int, itemsPerPage: Int, totalItemCount totalCount: Int) -> Int {
        let itemCount: Int
        if (pageIndex + 1) * itemsPerPage <= totalCount {
            itemCount = itemsPerPage
        } else {
            itemCount = totalCount - pageIndex * itemsPerPage
        }
        return itemCount
    }
    
    func mappedIndex(forPageIndex pageIndex: Int, itemsPerPage: Int, indexPath: IndexPath) -> Int {
        return pageIndex * itemsPerPage + indexPath.row
    }
    
    /*
    * Ditto above comment.
    */
    // MARK: - Search Page Convenience
    func configureSearchPage(forFiltered filtered: Bool) {
        switch filtered {
        case true:
            searchPageChild?.configure(
                totalItemCount: filteredContent.count,
                itemsPerPage: filteredContentItemsPerPage)
            searchPageChild?.giveButtonSelectedAppearance(pageNumber: 0)
            filteredContentActivePage = 0
            
        case false:
            searchPageChild?.configure(
                totalItemCount: allContent.count,
                itemsPerPage: allContentItemsPerPage)
            searchPageChild?.giveButtonSelectedAppearance(pageNumber: allContentActivePage)
        }
    }
    
    // MARK: - Keyboard / View Layout Management
    func keyboardWillShow(notification: Notification) {
        guard
            let finishRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationCurveConstant = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
                return
        }
        let vertDispl: CGFloat = finishRect.height
        keyboardConstraint.constant = vertDispl
        
        let animationOption = UIViewAnimationOptions(rawValue: UInt(animationCurveConstant))
        UIView.animate(
            withDuration: TimeInterval(animationDuration),
            delay: 0.0,
            options: animationOption,
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: nil)
    }
    
    func keyboardWillHide(notification: Notification) {
        guard
            let animationCurveConstant = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
                return
        }
        keyboardConstraint.constant = 0.0
        let animationOption = UIViewAnimationOptions(rawValue: UInt(animationCurveConstant))
        UIView.animate(
            withDuration: TimeInterval(animationDuration),
            delay: 0.0,
            options: animationOption,
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: nil)
    }
}














