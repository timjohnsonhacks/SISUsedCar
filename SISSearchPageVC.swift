//
//  SISSearchPageVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISSearchPageVC: UIViewController {

    private var totalItemCount: Int
    private var itemsPerPage: Int
    private var buttonSize: CGSize
    private weak var delegate: SISSearchPageButtonDelegate?
    private weak var searchStack: SISSearchPageButtonStack!
    private(set) public var lastSelectedPageNumber: Int?
    
    var totalPages: Int {
        return totalItemCount == 0 ? 0 : (totalItemCount - 1) / itemsPerPage + 1
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var pageLabel: UILabel!
    
    init(totalItemCount: Int, itemsPerPage: Int, buttonSize: CGSize, delegate: SISSearchPageButtonDelegate) {
        self.totalItemCount = totalItemCount
        self.itemsPerPage = itemsPerPage
        self.buttonSize = buttonSize
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsHorizontalScrollIndicator = false
        configure(
            totalItemCount: totalItemCount,
            itemsPerPage: itemsPerPage)
        scrollViewWidth.constant = 0.0
        pageLabel.textColor = SISGlobalConstants.calmBlue
        pageLabel.font = UIFont.systemFont(ofSize: 17.0)
        pageLabel.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureLayout()
    }
    
    private func configureLayout() {
        // page label appearance
        pageLabel.isHidden = totalItemCount == 0 ? true : false
        
        // width and content size config
        let totalWidthInset: CGFloat = 20.0
        let naturalFrame = searchStack.naturalFrame
        if view.bounds.size.width - totalWidthInset < searchStack.naturalFrame.size.width {
            
            scrollViewWidth.constant = view.bounds.size.width - totalWidthInset
            searchStack.frame = searchStack.naturalFrame
            scrollView.contentSize = naturalFrame.size
            scrollView.isScrollEnabled = true
            
        } else {
            
            scrollViewWidth.constant = searchStack.naturalFrame.size.width
            scrollView.contentSize = scrollView.bounds.size
            scrollView.isScrollEnabled = false
            
        }
        // height config
        scrollViewHeight.constant = naturalFrame.height
        
    }
    
    public func giveButtonSelectedAppearance(pageNumber: Int) {
        if totalItemCount == 0 {
            return
        }
        if let lastSelectedPageNumber = lastSelectedPageNumber {
            searchStack.buttons[lastSelectedPageNumber].isSelected = false
        }
        searchStack.buttons[pageNumber].isSelected = true
        lastSelectedPageNumber = pageNumber
        pageLabel.text = "Page \(pageNumber + 1) / \(totalPages)"
    }
    
    public func configure(totalItemCount: Int, itemsPerPage: Int) {
        searchStack?.removeFromSuperview()
        lastSelectedPageNumber = nil
        // create button view / setup scroll view
        self.totalItemCount = totalItemCount
        self.itemsPerPage = itemsPerPage
        
        let ss = SISSearchPageButtonStack(
            totalPages: totalPages,
            buttonSize: buttonSize,
            spacing: 2.0,
            color_1: SISGlobalConstants.calmBlue,
            color_2: .white,
            borderWidth: 2.0,
            delegate: delegate!)
        scrollView.addSubview(ss)
        searchStack = ss
        
        // layout
        configureLayout()
    }
}

















